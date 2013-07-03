require 'tmpdir'

ghc_versions = node.haskell.multi.ghcs
linux_platform = 'unknown-linux'
arch = node.ghc.arch

installation_root = File.join(node.travis_build_environment.home, "ghc-multi")
installation_bin = File.join(installation_root, 'bin')

[installation_root, installation_bin].each do |d|
  directory d do
    owner node.travis_build_environment.user
    group node.travis_build_environment.group
    mode "0755"
    action :create
  end
end

ghc_tmp_dir = Dir.tmpdir
ghc_versions.each_pair do |ghc_version, settings|
  platform_version = settings[:platform_version]
  ghc_tarball_name = "ghc-#{ghc_version}-#{arch}-#{linux_platform}.tar.bz2"
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
      rm -rf ghc-#{ghc_version}
      rm -v #{ghc_local_tarball}
      ln -sf #{ghc_dir}/bin/ghc /usr/local/bin/ghc
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
      rm /usr/local/bin/ghc -v
    EOS
  end

  ["ghc","ghc-pkg","haddock-ghc"].each do |ghc_binary|
    binary_file = "#{ghc_binary}-#{ghc_version}"
    link File.join(installation_bin, binary_file) do
      to File.join(ghc_dir, "bin", binary_file)
    end
  end
end

default_ghc = ghc_versions.select { |_,v| v.has_key?(:default) and v[:default] }.keys.first
["ghc","ghc-pkg","haddock-ghc"].each do |ghc_binary|
  link "/usr/local/bin/#{ghc_binary}" do
    to File.join(installation_bin, "#{ghc_binary}-#{default_ghc}")
  end
end
