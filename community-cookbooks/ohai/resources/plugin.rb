property :plugin_name, String, name_property: true
property :path, String
property :source_file, String
property :cookbook, String
property :resource, [:cookbook_file, :template], default: :cookbook_file
property :variables, Hash
property :compile_time, [true, false], default: true

action :create do
  # why create_if_missing you ask?
  # no one can agree on perms and this allows them to manage the perms elsewhere
  directory desired_plugin_path do
    action :create
    recursive true
    not_if { ::File.exist?(desired_plugin_path) }
  end

  if new_resource.resource.eql?(:cookbook_file)
    cookbook_file ::File.join(desired_plugin_path, new_resource.plugin_name + '.rb') do
      cookbook new_resource.cookbook
      source new_resource.source_file || "#{new_resource.plugin_name}.rb"
      notifies :reload, "ohai[#{new_resource.plugin_name}]", :immediately
    end
  elsif new_resource.resource.eql?(:template)
    template ::File.join(desired_plugin_path, new_resource.plugin_name + '.rb') do
      cookbook new_resource.cookbook
      source new_resource.source_file || "#{new_resource.plugin_name}.rb"
      variables new_resource.variables
      notifies :reload, "ohai[#{new_resource.plugin_name}]", :immediately
    end
  end

  # Add the plugin path to the ohai plugin path if need be and warn
  # the user that this is going to result in a reload every run
  unless in_plugin_path?(desired_plugin_path)
    plugin_path_warning
    Chef::Log.warn("Adding #{desired_plugin_path} to the Ohai plugin path for this chef-client run only")
    add_to_plugin_path(desired_plugin_path)
    reload_required = true
  end

  ohai new_resource.plugin_name do
    action :nothing
    action :reload if reload_required
  end
end

action :delete do
  file ::File.join(desired_plugin_path, new_resource.plugin_name + '.rb') do
    action :delete
    notifies :reload, 'ohai[reload ohai post plugin removal]'
  end

  ohai 'reload ohai post plugin removal' do
    action :nothing
  end
end

action_class do
  # return the path property if specified or
  # CHEF_CONFIG_PATH/ohai/plugins if a path isn't specified
  def desired_plugin_path
    if new_resource.path
      new_resource.path
    else
      ::File.join(chef_config_path, 'ohai', 'plugins')
    end
  end

  # return the chef config files dir or fail hard
  def chef_config_path
    if Chef::Config['config_file']
      ::File.dirname(Chef::Config['config_file'])
    else
      Chef::Application.fatal!("No chef config file defined. Are you running \
chef-solo? If so you will need to define a path for the ohai_plugin as the \
path cannot be determined")
    end
  end

  # is the desired plugin dir in the ohai config plugin dir array?
  def in_plugin_path?(path)
    # get the directory where we plan to stick the plugin (not the actual file path)
    desired_dir = ::File.directory?(path) ? path : ::File.dirname(path)

    case node['platform']
    when 'windows'
      ::Ohai::Config.ohai['plugin_path'].map(&:downcase).include?(desired_dir.downcase)
    else
      ::Ohai::Config.ohai['plugin_path'].include?(desired_dir)
    end
  end

  def add_to_plugin_path(path)
    ::Ohai::Config.ohai['plugin_path'] << path # new format
  end

  # we need to warn the user that unless the path for this plugin is in Ohai's
  # plugin path already we're going to have to reload Ohai on every Chef run.
  # Ideally in future versions of Ohai /etc/chef/ohai/plugins is in the path.
  def plugin_path_warning
    Chef::Log.warn("The Ohai plugin_path does not include #{desired_plugin_path}. \
Ohai will reload on each chef-client run in order to add this directory to the \
path unless you modify your client.rb configuration to add this directory to \
plugin_path. The plugin_path can be set via the chef-client::config recipe. \
See 'Ohai Settings' at https://docs.chef.io/config_rb_client.html#ohai-settings \
for more details.")
  end
end

# this resource forces itself to run at compile_time
def after_created
  return unless compile_time
  Array(action).each do |action|
    run_action(action)
  end
end
