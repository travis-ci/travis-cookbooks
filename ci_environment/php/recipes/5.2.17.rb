include_recipe "bison"
include_recipe "libreadline"

include_recipe "phpenv"
include_recipe "phpbuild"

# This recipe downloads our own 5.2.17 archive for Precise

if node[:platform] == 'ubuntu' && node[:platform_version] == '12.04'
  require 'tmpdir'

  local_archive = File.join(Dir.tmpdir, 'php-5.2.17.tar.bz2')

  remote_file local_archive do
    source 'https://s3.amazonaws.com/travis-php-archives/php-5.2.17.tar.bz2'
    checksum '5deb018f585fb40d781917e6cd744f3ecaf8aabbc6eaf53d4f1300e61d8fd915'
  end

  bash 'Expand PHP 5.2.17 archive' do
    user node.travis_build_environment.user
    group node.travis_build_environment.group

    code <<-EOF
      tar xjf #{local_archive} --directory #{File.join(node.travis_build_environment.home, '.phpenv', 'versions')}
    EOF

    not_if File.exist?(File.join(node.travis_build_environment.home, '.phpenv', 'versions', '5.2.17'))
  end
end