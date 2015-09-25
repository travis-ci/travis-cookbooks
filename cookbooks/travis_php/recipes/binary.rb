include_recipe "bison"
include_recipe "libreadline"

include_recipe "travis_phpenv"
include_recipe "travis_phpbuild"

# This recipe downloads our own 5.2.17 archive for Precise

if node[:platform] == 'ubuntu' && node[:platform_version] == '12.04'
  require 'tmpdir'

  node.php.binaries.each do |php|
    local_archive = File.join(Dir.tmpdir, "php-#{php[:version]}.tar.bz2")

    remote_file local_archive do
      source "https://s3.amazonaws.com/travis-php-archives/php-#{php[:version]}.tar.bz2"
      checksum php[:checksum]
    end

    bash "Expand PHP #{php[:version]} archive" do
      user node.travis_build_environment.user
      group node.travis_build_environment.group

      code <<-EOF
        tar xjf #{local_archive} --directory #{File.join(node.travis_build_environment.home, '.phpenv', 'versions')}
      EOF

      not_if File.exist?(File.join(node.travis_build_environment.home, '.phpenv', 'versions', php[:version]))
    end
  end
end
