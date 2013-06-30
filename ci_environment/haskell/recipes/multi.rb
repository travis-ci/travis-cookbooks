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
ghc_versions.each do |v|
  local_tarball = File.join(ghc_tmp_dir, "ghc-#{v}-#{arch}-#{linux_platform}.tar.bz2")
  ghc_dir = File.join(installation_root, v)
  remote_file local_tarball  do
    source "http://www.haskell.org/ghc/dist/#{v}/ghc-#{v}-#{arch}-#{linux_platform}.tar.bz2"
    not_if "test -f #{local_tarball}"
  end

  bash "build and install GHC" do
    user "root"
    cwd  "/tmp"
    code <<-EOS
      tar jfx #{local_tarball}
      cd ghc-#{v}
      ./configure --prefix=#{ghc_dir}
      sudo make install
      rm -rf ghc-#{v}
      rm -v #{local_tarball}
      cd ../
    EOS
  end

  ["ghc","ghc-pkg","haddock-ghc"].each do |b|
    binary = "#{b}-#{v}"
    link File.join(installation_bin, binary) do
      to File.join(ghc_dir, "bin", binary)
    end
  end
end
