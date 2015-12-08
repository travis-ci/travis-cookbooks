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
  end

  # Install all of the pre-installed packages we want
  execute "install packages #{venv_name}" do
    command "#{venv_fullname}/bin/pip install --upgrade #{packages.join(' ')}"
    user    node.travis_build_environment.user
    group   node.travis_build_environment.group
    environment(
      'HOME' => node['travis_build_environment']['home']
    )
  end
end
