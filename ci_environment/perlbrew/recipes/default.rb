# Make sure that the package list is up to date on Ubuntu/Debian.
include_recipe "apt" if ['debian', 'ubuntu'].member? node[:platform]

# Make sure we have all we need to compile Perl implementations:
package "perl"
include_recipe "networking_basic"
include_recipe "build-essential"

bash "install Perlbrew" do
  user        node.travis_build_environment.user
  cwd         node.travis_build_environment.home
  environment Hash['HOME' => node.travis_build_environment.home]
  code        <<-SH
  curl -s https://raw.github.com/gugod/App-perlbrew/master/perlbrew-install -o /tmp/perlbrew-installer
  chmod +x /tmp/perlbrew-installer
  /tmp/perlbrew-installer
  SH
  not_if      "test -d #{node.travis_build_environment.home}/perl5/perlbrew"
end

cookbook_file "/etc/profile.d/perlbrew.sh" do
  owner node.travis_build_environment.user
  group node.travis_build_environment.group
  mode 0755
end

