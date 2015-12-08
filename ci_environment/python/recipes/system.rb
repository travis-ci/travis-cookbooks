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
  venv_name = "#{virtualenv_root}/#{pyname}_with_system_site_packages"

  python_virtualenv "#{pyname}_with_system_site_packages" do
    owner                node.travis_build_environment.user
    group                node.travis_build_environment.group
    interpreter          "/usr/bin/#{pyname}"
    path                 venv_name
    system_site_packages true

    action :create
  end

  # Build a list of packages up so that we can install them
  packages = []
  node.python.pyenv.aliases.fetch(py, []).concat(["default", py]).each do |name|
    packages.concat node.python.pip.packages.fetch(name, [])
  end

  execute "install wheel in #{pyname}_with_system_site_packages" do
    command "#{venv_name}/bin/pip install --upgrade wheel"
    user    node.travis_build_environment.user
    group   node.travis_build_environment.group
  end

  # Install all of the pre-installed packages we want
  execute "install packages #{pyname}_with_system_site_packages" do
    command "#{venv_name}/bin/pip install --upgrade #{packages.join(' ')}"
    user    node.travis_build_environment.user
    group   node.travis_build_environment.group
  end
end
