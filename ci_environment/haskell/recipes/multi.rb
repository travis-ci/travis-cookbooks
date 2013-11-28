require 'tmpdir'

ghc_versions = node[:haskell][:multi][:ghcs]

installation_root = File.join(node.travis_build_environment.home, "ghc-multi")
installation_bin = File.join(installation_root, "bin")
bin_path = "/usr/local/bin/"
ghc_binaries = ["ghc","ghc-pkg","haddock-ghc","ghci"]

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

# create necessary dirs
[installation_root, installation_bin].each do |d|
  directory d do
    owner node.travis_build_environment.user
    group node.travis_build_environment.group
    mode "0755"
    action :create
  end
end

# download, unpack, build and install each ghc compiler and relater platform from sources
ghc_tmp_dir = Dir.tmpdir
ghc_versions.each_pair do |ghc_version, settings|
  platform_version = settings[:platform_version]
  ghc_tarball_name = "ghc-#{ghc_version}-#{node.ghc.arch}-unknown-linux.tar.bz2"
  ghc_local_tarball = File.join(ghc_tmp_dir, ghc_tarball_name)
  ghc_dir = File.join(installation_root, ghc_version)

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
      ./configure --prefix=#{ghc_dir}
      sudo make install
      cd ..
      rm -rf ghc-#{ghc_version}
      rm -v #{ghc_local_tarball}
      ln -sf #{ghc_dir}/bin/ghc #{bin_path}/ghc
      cd ../
    EOS
  end

  platform_tarball_name = "haskell-platform-#{platform_version}.tar.gz"
  platform_local_tarball = File.join(ghc_tmp_dir, platform_tarball_name)

  remote_file platform_local_tarball do
    source "http://lambda.haskell.org/platform/download/#{platform_version}/#{platform_tarball_name}"
    not_if "test -f #{platform_local_tarball}"
  end

  bash "build and install Haskell Platform" do
    user "root"
    cwd  "/tmp"
    code <<-EOS
      tar zfx #{platform_local_tarball}
      cd `tar -tf #{platform_local_tarball} | head -n 1`

      which ghc
      ghc --version

      ./configure --prefix=#{ghc_dir}
      sudo make && sudo make install
      cd ../
      rm -rf `tar -tf #{platform_local_tarball} | head -n 1`
      rm #{platform_local_tarball}

      cabal update
      cabal install hunit c2hs
      rm #{bin_path}/ghc -v
    EOS
  end

  ghc_binaries.each do |ghc_binary|
    binary_file = "#{ghc_binary}-#{ghc_version}"
    link File.join(installation_bin, binary_file) do
      to File.join(ghc_dir, "bin", binary_file)
    end
  end
end

# link all ghc binaries to bin_path
default_ghc = ghc_versions.select { |_,v| v.has_key?(:default) and v[:default] }.keys.first
ghc_binaries.each do |ghc_binary|
  link File.join(bin_path, ghc_binary) do
    to File.join(installation_bin, "#{ghc_binary}-#{default_ghc}")
  end
end

template File.join(installation_root, "ghc-select") do
  source "ghc-select.erb"
  mode 0755
  owner "root"
  group "root"
  variables({
     :bin_dir => installation_bin,
     :global_bin => bin_path,
     :ghc_binaries => ghc_binaries,
  })
end
