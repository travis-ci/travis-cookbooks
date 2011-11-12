action :create do
  unless exists?
    Chef::Log.info("Installing PHP #{@new_resource.version} with php-build")
    new_resource = @new_resource
    phpbuild_path = "#{node[:phpbuild][:home]}/.php-build"
    version = new_resource.version
    target_path = "#{new_resource.path}/#{version}"
    bash "install PHP #{version} with php-build" do
      user   new_resource.owner
      group  new_resource.group
      environment Hash["HOME" => node[:phpbuild][:home]]
      cwd    "#{phpbuild_path}/bin"
      code <<-EOF
      echo "./php-build -i development #{version} #{target_path}"
      ./php-build -i development #{version} #{target_path}
      EOF
    end

    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if exists?
    Chef::Log.info("Uninstalling PHP #{@new_resource.version} from php-build")
    phpbuild_path = "#{node[:phpbuild][:home]}/.php-build"
    target_path = "#{@new_resource.path}/#{@new_resource.version}"
    FileUtils.rm_rf(target_path)
    new_resource.updated_by_last_action(true)
  end
end

private
def exists?
  phpbuild_path = "#{node[:phpbuild][:home]}/.php-build"
  target_path = "#{@new_resource.path}/#{@new_resource.version}"
  ::File.exist?(target_path) && ::File.directory?(target_path) \
    && ::File.exists?("#{target_path}/bin/php") && ::File.exists?("#{target_path}/bin/phpunit")
end
