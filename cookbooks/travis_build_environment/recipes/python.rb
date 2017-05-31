
virtualenv_root = "#{node['travis_build_environment']['home']}/virtualenv"

include_recipe 'travis_build_environment::virtualenv'

package %w(
  build-essential
  curl
  libbz2-dev
  liblzma-dev
  libncurses-dev
  libreadline-dev
  libsqlite3-dev
  libssl-dev
  llvm
  make
  tk-dev
  wget
  zlib1g-dev
)

git '/opt/pyenv' do
  repository 'https://github.com/yyuu/pyenv.git'
  revision node['travis_build_environment']['pyenv']['revision']
  action :sync
end

execute '/opt/pyenv/plugins/python-build/install.sh'

directory '/opt/python' do
  owner 'root'
  group 'root'
  mode 0o755
end

directory virtualenv_root do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
end

build_environment = {
  'PYTHON_CONFIGURE_OPTS' => %w(
    --enable-unicode=ucs4
    --with-wide-unicode
    --enable-shared
    --enable-ipv6
    --enable-loadable-sqlite-extensions
    --with-computed-gotos
  ).join(' '),
  'PYTHON_CFLAGS' => %w(
    -g
    -fstack-protector
    --param=ssp-buffer-size=4
    -Wformat
    -Werror=format-security
  ).join(' ')
}

bindirs = %w(/opt/pyenv/bin)

node['travis_build_environment']['pyenv']['pythons'].each do |py|
  pyname = py
  downloaded_tarball = ::File.join(
    Chef::Config[:file_cache_path], "#{py}.tar.bz2"
  )

  if /^\d+\.\d+(?:\.\d+)?(?:-dev)?$/ =~ py
    pyname = "python#{py}"
    downloaded_tarball = ::File.join(
      Chef::Config[:file_cache_path], "python-#{py}.tar.bz2"
    )
  end

  venv_fullname = "#{virtualenv_root}/#{pyname}"

  remote_file downloaded_tarball do
    source ::File.join(
      'https://s3.amazonaws.com/travis-python-archives/binaries',
      node['platform'],
      node['platform_version'],
      node['kernel']['machine'],
      ::File.basename(downloaded_tarball)
    )
    owner 'root'
    group 'root'
    mode 0o644
    ignore_failure true
  end

  bash "extract #{downloaded_tarball}" do
    code "tar -xjf #{downloaded_tarball} --directory /"
    creates "/opt/python/#{py}"
    environment build_environment
    only_if { File.exist?(downloaded_tarball) }
  end

  bash "build #{py}" do
    code "python-build #{py} /opt/python/#{py}"
    creates "/opt/python/#{py}"
    environment build_environment
    not_if { File.exist?("/opt/python/#{py}") }
  end

  link "/opt/python/#{py}/bin/#{pyname}" do
    to "/opt/python/#{py}/bin/python"
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
  end

  bindirs << "/opt/python/#{py}/bin"

  bash "create virtualenv at #{venv_fullname} from #{py}" do
  code "virtualenv --python=/opt/python/#{py}/bin/python #{venv_fullname}"
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end

  node['travis_build_environment']['pyenv']['aliases'].fetch(py, []).each do |pyalias|
    if /^\d+\.\d+(?:\.\d+)?(?:-dev)?$/ =~ py
      pyaliasname = "python#{pyalias}"
    else
      pyaliasname = pyalias
    end

    link "#{virtualenv_root}/#{pyaliasname}" do
      to venv_fullname
      owner node['travis_build_environment']['user']
      group node['travis_build_environment']['group']
    end
  end

  if py =~ /^pypy3/
    link "/opt/python/#{py}/bin/pypy3" do
      to "/opt/python/#{py}/bin/#{py}"
      not_if "test -f /opt/python/#{py}/bin/pypy3"
    end
  end

  packages = []

  node['travis_build_environment']['pyenv']['aliases'].fetch(py, []).concat(['default', py]).each do |name|
    packages.concat(node['travis_build_environment']['pip']['packages'].fetch(name, []))
  end

  execute "install wheel in #{py}" do
    command "#{venv_fullname}/bin/pip install --upgrade wheel"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment(
      'HOME' => node['travis_build_environment']['home']
    )
  end

  execute "install packages in #{py}" do
    command "#{venv_fullname}/bin/pip install --upgrade #{packages.join(' ')}"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment(
      'HOME' => node['travis_build_environment']['home']
    )
  end
end

template '/etc/profile.d/pyenv.sh' do
    source 'pyenv.sh.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o644
  variables(
    bindirs: bindirs,
    build_environment: build_environment
  )
  backup false
end
