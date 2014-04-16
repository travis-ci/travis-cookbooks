require 'tmpdir'

# install some deps
%w(libgmp3-dev freeglut3 freeglut3-dev).each do |pkg|
  package(pkg) do
    action :install
  end
end

case [node.platform, node.platform_version]
when ["ubuntu", "11.10"] then
  link "/usr/lib/libgmp.so.3" do
    to "/usr/lib/libgmp.so"

    not_if "test -L /usr/lib/libgmp.so.3"
  end
when ["ubuntu", "12.04"] then
  package "libgmp3c2"

  link "/usr/lib/libgmp.so.3" do
    to "/usr/lib/libgmp.so.3.5.2"

    not_if "test -L /usr/lib/libgmp.so.3"
  end
end

ghc_dir = "/usr/local/ghc"

directory ghc_dir do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0755
  action :create
end

# download, unpack, build and install each ghc compiler and relater platform from sources
ghc_tmp_dir = Dir.tmpdir
node[:haskell][:multi][:ghcs].each do |ghc_version|
  linux_name = ghc_version =~ /^7.8/ ? "-deb7" : ""
  ghc_tarball_name = "ghc-#{ghc_version}-#{node.ghc.arch}-unknown-linux#{linux_name}.tar.bz2"
  ghc_local_tarball = File.join(ghc_tmp_dir, ghc_tarball_name)
  ghc_version_dir = File.join(ghc_dir, ghc_version)

  directory ghc_version_dir do
    owner node.travis_build_environment.user
    group node.travis_build_environment.group
    mode 0755
    action :create
  end

  remote_file ghc_local_tarball  do
    source "http://www.haskell.org/ghc/dist/#{ghc_version}/#{ghc_tarball_name}"
    not_if "test -f #{ghc_local_tarball}"
  end

  bash "build and install GHC" do
    user "root"
    cwd  "/tmp"
    code <<-EOS
      tar jfx #{ghc_local_tarball}
      cd ghc-#{ghc_version}
      ./configure --prefix=#{ghc_version_dir}
      make install
      cd ..
      rm -rf ghc-#{ghc_version}
      rm -v #{ghc_local_tarball}
    EOS
  end
end

# install cabal
apt_repository "cabal-install-ppa" do
  uri          "http://ppa.launchpad.net/typeful/cabal-install/ubuntu"
  distribution node['lsb']['codename']
  components   ["main"]
  key          "9DF71E85"
  keyserver    "keyserver.ubuntu.com"
  action :add
end

%w(cabal-install alex happy).each do |p|
  package p do
    action :install
  end
end

cookbook_file "/etc/profile.d/cabal.sh" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0755
end

template "/usr/local/bin/ghc_find" do
  source "ghc_find.erb"
  mode 0755
  owner "root"
  group node.travis_build_environment.group
  variables({
    :versions => node[:haskell][:multi][:ghcs].sort.reverse,
    :default => node[:haskell][:multi][:default],
  })
end
