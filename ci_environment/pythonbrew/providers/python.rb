action :create do
  unless exists?
    new_resource = @new_resource
    bash "Install Python #{new_resource.version} with Pythonbrew" do
      user        new_resource.owner
      group       new_resource.group

      environment Hash["HOME" => node.travis_build_environment.home]
      cwd         node.travis_build_environment.home

      code <<-EOF
      ~/.pythonbrew/bin/pythonbrew install --no-test #{new_resource.version}
      EOF
    end
  end
end

action :delete do
  if exists?
    Chef::Log.info("Uninstalling Python #{@new_resource.version} installed via Pythonbrew")
    pythons_path  = ::File.join(node.travis_build_environment.home, ".pythonbrew", "pythons")
    resource_path = ::File.join(pythons_path, "Python-#{@new_resource.version}")

    FileUtils.rm_rf(resource_path)
    new_resource.updated_by_last_action(true)
  end
end

protected

def exists?
  pythons_path  = ::File.join(node.travis_build_environment.home, ".pythonbrew", "pythons")
  resource_path = ::File.join(pythons_path, "Python-#{@new_resource.version}")

  ::File.exists?(resource_path) && ::File.directory?(resource_path)
end
