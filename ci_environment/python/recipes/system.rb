virtualenv_root = File.join(node.travis_build_environment.home, "virtualenv")

# Install Python2 and Python3
package "python-dev"
package "python3-dev"

# Create a directory to store our virtualenvs in
directory virtualenv_root do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode  "0755"

  action :create
end

# We assume these are Python 2.7 and Python 3.2, this will need changed on a
# new OS version
["2.7", "3.2"].each do |py|
  cache_tarball = ::File.join(
    Chef::Config[:file_cache_path],
    "system-python#{py}-virtualenv.tar.bz2"
  )

  remote_file cache_tarball do
    source ::File.join(
      'https://s3.amazonaws.com/travis-python-archives/binaries',
      node['platform'],
      node['platform_version'],
      node['kernel']['machine'],
      ::File.basename(cache_tarball)
    )
    mode 0644
    ignore_failure true
  end

  bash "extract #{cache_tarball}" do
    code "tar -C / -xjf #{cache_tarball}"
    only_if { ::File.exist?(cache_tarball) }
  end

  pyname = "python#{py}"
  venv_name = "#{pyname}_with_system_site_packages"
  venv_fullname = "#{virtualenv_root}/#{venv_name}"

  python_virtualenv venv_name do
    owner                node.travis_build_environment.user
    group                node.travis_build_environment.group
    interpreter          "/usr/bin/#{pyname}"
    path                 venv_fullname
    system_site_packages true

    action :create

    not_if { ::File.exist?(cache_tarball) }
  end

  # Build a list of packages up so that we can install them
  packages = []
  node.python.pyenv.aliases.fetch(py, []).concat(["default", py]).each do |name|
    packages.concat node.python.pip.packages.fetch(name, [])
  end

  execute "install wheel in #{venv_name}" do
    command "#{venv_fullname}/bin/pip install --upgrade wheel"
    user    node.travis_build_environment.user
    group   node.travis_build_environment.group
    environment(
      'HOME' => node['travis_build_environment']['home']
    )
    not_if { ::File.exist?(cache_tarball) }
  end

  # Install all of the pre-installed packages we want
  execute "install packages #{venv_name}" do
    command "#{venv_fullname}/bin/pip install --upgrade #{packages.join(' ')}"
    user    node.travis_build_environment.user
    group   node.travis_build_environment.group
    environment(
      'HOME' => node['travis_build_environment']['home']
    )
    not_if { ::File.exist?(cache_tarball) }
  end
end
