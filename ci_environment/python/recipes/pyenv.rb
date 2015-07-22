virtualenv_root = "#{node['travis_build_environment']['home']}/virtualenv"

include_recipe "python::virtualenv"

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
  revision node['python']['pyenv']['revision']
  action :sync
end

execute '/opt/pyenv/plugins/python-build/install.sh'

directory '/opt/python' do
  owner 'root'
  group 'root'
  mode 0755
end

directory virtualenv_root do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0755
end

bindirs = []

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
  ).join(' '),
}

node['python']['pyenv']['pythons'].each do |py|
  if /^\d+\.\d+(?:\.\d+)?(?:-dev)?$/ =~ py
    pyname = "python#{py}"
  else
    pyname = py
  end

  execute "python-build #{py} /opt/python/#{py}" do
    creates "/opt/python/#{py}"
    environment build_environment
  end

  link "/opt/python/#{py}/bin/#{pyname}" do
    to "/opt/python/#{py}/bin/python"
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
  end

  bindirs << "/opt/python/#{py}/bin"

  python_virtualenv "python_#{py}" do
    owner node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    interpreter "/opt/python/#{py}/bin/python"
    path "#{virtualenv_root}/#{pyname}"
    action :create
  end

  node['python']['pyenv']['aliases'].fetch(py, []).each do |pyalias|
    if /^\d+\.\d+(?:\.\d+)?(?:-dev)?$/ =~ py
      pyaliasname = "python#{pyalias}"
    else
      pyaliasname = pyalias
    end

    link "#{virtualenv_root}/#{pyaliasname}" do
      to "#{virtualenv_root}/#{pyname}"
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
  node['python']['pyenv']['aliases'].fetch(py, []).concat(['default', py]).each do |name|
    packages.concat(node['python']['pip']['packages'].fetch(name, []))
  end

  execute "install packages #{py}" do
    command "#{virtualenv_root}/#{pyname}/bin/pip install --upgrade #{packages.join(' ')}"
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
  mode 0644
  variables(
    bindirs: bindirs,
    build_environment: build_environment,
  )
  backup false
end
