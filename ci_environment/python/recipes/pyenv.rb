virtualenv_root = File.join(node.travis_build_environment.home, "virtualenv")

# Install virtualenv and pip
include_recipe "python::virtualenv"

# Get pyenv which we'll use to install the various Pythons we wish to support
git "/opt/pyenv" do
  repository "git://github.com/yyuu/pyenv.git"
  revision   node.python.pyenv.revision

  action :sync
end

# Install pyenv's python-build command so that it's available in the system
execute "/opt/pyenv/plugins/python-build/install.sh"

# Create a directory to store all of our Pythons in
directory "/opt/python" do
  owner "root"
  group "root"
  mode  "755"

  action :create
end

# Create a directory to store our virtualenvs in
directory virtualenv_root do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode  "0755"

  action :create
end

# Install the baked in versions of Python we are offering
node.python.pyenv.pythons.each do |py|
  # Actually do the installation/building to the full version python
  execute "python-build #{py} /opt/python/#{py}" do
    creates "/opt/python/#{py}"
  end

  # Create our virtualenvs for this python
  python_virtualenv "python_#{py}" do
    owner       node.travis_build_environment.user
    group       node.travis_build_environment.group
    interpreter "/opt/python/#{py}/bin/python"
    path        "#{virtualenv_root}/#{py}"

    action :create
  end

  # Add any aliases that exist for this Python version
  node.python.pyenv.aliases.fetch(py, []).each do |pyalias|
    link "#{virtualenv_root}/#{pyalias}" do
      to    "#{virtualenv_root}/#{py}"
      owner node.travis_build_environment.user
      group node.travis_build_environment.group
    end
  end

  # Build a list of packages up so that we can install them
  packages = []
  node.python.pyenv.aliases.fetch(py, []).concat(["default", py]).each do |name|
    packages.concat node.python.pip.packages.fetch(name, [])
  end

  # Install all of the pre-installed packages we want
  execute "install packages #{py}_with_system_site_packages" do
    command "#{virtualenv_root}/#{py}_with_system_site_packages/bin/pip install --upgrade #{packages.join(' ')}"
    user    node.travis_build_environment.user
    group   node.travis_build_environment.group
  end
end
