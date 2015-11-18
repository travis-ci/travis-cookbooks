module SystemInfoRecipeMethods
  include Chef::Mixin::ShellOut

  def run_system_info(options = {})
    require 'rbconfig'

    Chef::Resource::Execute.new(
      "#{RbConfig.ruby} -S system-info -- report #{system_info_options(options)}",
      run_context
    )
  end

  private

  def system_info_options(options)
    %W(
      --formats human,json
      --human-output #{options.fetch(:dest_dir)}/system_info
      --json-output #{options.fetch(:dest_dir)}/system_info.json
      --commands-file #{options.fetch(:commands_file)}
      --cookbooks-sha #{options.fetch(:cookbooks_sha)}
    ).join(' ')
  end
end

Chef::Recipe.send(:include, SystemInfoRecipeMethods)
