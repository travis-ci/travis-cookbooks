include_recipe "php::multi"

phpenv_path = "#{node.phpenv.home}/.phpenv"

node[:php][:multi][:versions].each do |php_version|

  bin_path = "#{phpenv_path}/versions/#{php_version}/bin"
  remote_file "#{bin_path}/composer.phar" do
    source "http://getcomposer.org/composer.phar"
    mode   "0644"
  end

  template "#{bin_path}/composer" do
    owner  node[:phpbuild][:user]
    group  node[:phpbuild][:group]
    mode   "0755"
    source "composer.erb"
    variables(
      :phpbin_path => bin_path
    )
  end
end
