module SystemInfoMethods
  def system_info_command(options = {})
    "#{system_info_exe} report #{system_info_options(options)}"
  end

  private

  def system_info_exe
    '/opt/chef/embedded/bin/system-info'
  end

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
