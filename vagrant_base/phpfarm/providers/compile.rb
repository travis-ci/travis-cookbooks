action :create do
  unless exists?
    Chef::Log.info("Installing PHP #{@new_resource} with phpfarm")
    new_resource = @new_resource
    phpfarm_path = "#{node.phpfarm.home}/.phpfarm"
    version = new_resource.version
    bash "install PHP with phpfarm" do
      user new_resource.owner
      group new_resource.group
      cwd Chef::Config[:file_cache_path]
      code <<-EOF
      cd #{phpfarm_path}/src
      ./compile.sh #{version}
      EOF
      not_if "test -f #{phpfarm_path}/inst/bin/php-#{version}"
    end

    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if exists?
    Chef::Log.info("Uninstalling PHP #{@new_resource} from phpfarm")
    phpfarm_path = "#{node.phpfarm.home}/.phpfarm"
    version = @new_resource.version
    FileUtils.rm_rf("#{phpfarm_path}/inst/php-#{version}/")
    FileUtils.rm_rf("#{phpfarm_path}/inst/bin/php-#{version}")
    new_resource.updated_by_last_action(true)
  end
end

private
def exists?
  phpfarm_path = "#{node.phpfarm.home}/.phpfarm"
  version = @new_resource.version
  ::File.exist?("#{phpfarm_path}/inst/php-#{version}/") && ::File.directory?("#{phpfarm_path}/inst/php-#{version}/") \
    && ::File.exists?("#{phpfarm_path}/inst/bin/php-#{version}")
end
