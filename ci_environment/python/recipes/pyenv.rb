virtualenv_root = File.join(node.travis_build_environment.home, "virtualenv")

# Install virtualenv and pip
include_recipe "python::virtualenv"

# Install the things we need to properly build Python
[
  "make", "build-essential", "libssl-dev", "zlib1g-dev", "libbz2-dev",
  "libreadline-dev", "libsqlite3-dev", "wget", "curl", "llvm", "liblzma-dev",
  "libncurses-dev", "tk-dev",
].each do |pkg|
  package pkg
end

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

# Store a list of all of our bin dirs
bindirs = Array.new

# python-build environment variables
build_environment = {
  # Adapted from Ubuntu 14.04's python3.4 package
  "PYTHON_CONFIGURE_OPTS" => "--enable-unicode=ucs4 --with-wide-unicode --enable-shared --enable-ipv6 --enable-loadable-sqlite-extensions --with-computed-gotos",
  "PYTHON_CFLAGS" => "-g -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security",
}

# Install the baked in versions of Python we are offering
node.python.pyenv.pythons.each do |py|
  # Get our on disk name for this python
  if /^\d+\.\d+(?:\.\d+)?(?:-dev)?$/ =~ py
    pyname = "python#{py}"
  else
    pyname = py
  end

  # Actually do the installation/building to the full version python
  execute "python-build #{py} /opt/python/#{py}" do
    creates "/opt/python/#{py}"
    environment build_environment
  end

  # Add a nonstandard pythonX.Y.Z command in order to support multiple installs
  # of the exact same X.Y release.
  link "/opt/python/#{py}/bin/#{pyname}" do
    to    "/opt/python/#{py}/bin/python"
    owner node.travis_build_environment.user
    group node.travis_build_environment.group
  end

  # Record our bindir
  bindirs << "/opt/python/#{py}/bin"

  # Create our virtualenvs for this python
  python_virtualenv "python_#{py}" do
    owner       node.travis_build_environment.user
    group       node.travis_build_environment.group
    interpreter "/opt/python/#{py}/bin/python"
    path        "#{virtualenv_root}/#{pyname}"

    action :create
  end

  # Add any aliases that exist for this Python version
  node.python.pyenv.aliases.fetch(py, []).each do |pyalias|
    if /^\d+\.\d+(?:\.\d+)?(?:-dev)?$/ =~ py
      pyaliasname = "python#{pyalias}"
    else
      pyaliasname = pyalias
    end

    link "#{virtualenv_root}/#{pyaliasname}" do
      to    "#{virtualenv_root}/#{pyname}"
      owner node.travis_build_environment.user
      group node.travis_build_environment.group
    end
  end

  # Create a symlink 'pypy3' that points to PyPy3 binary
  # We need to get around https://bitbucket.org/pypy/pypy/issue/1796/pypy-pypy3-in-the-same-path
  if py =~ /^pypy3/
    link "/opt/python/#{py}/bin/pypy3" do
      to "/opt/python/#{py}/bin/#{py}"
      not_if "test -f /opt/python/#{py}/bin/pypy3"
    end
  end

  # Build a list of packages up so that we can install them
  packages = []
  node.python.pyenv.aliases.fetch(py, []).concat(["default", py]).each do |name|
    packages.concat node.python.pip.packages.fetch(name, [])
  end

  # Install all of the pre-installed packages we want
  execute "install packages #{py}" do
    command "#{virtualenv_root}/#{pyname}/bin/pip install --upgrade #{packages.join(' ')}"
    user    node.travis_build_environment.user
    group   node.travis_build_environment.group
  end
end

# Create a profile script that adds our Python bins to the $PATH
template "/etc/profile.d/pyenv.sh" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0755

  variables({
    :bindirs => bindirs,
    :build_environment => build_environment,
  })

  source "pyenv.sh.erb"
  backup false
end
