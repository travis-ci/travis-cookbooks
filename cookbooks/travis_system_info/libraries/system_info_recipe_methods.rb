module SystemInfoRecipeMethods
  def run_system_info(options = {})
    try_become_user(options.fetch(:user))

    require 'system-info'

    SystemInfo::Cli.start(%w(reports) + system_info_options(options))
  end

  private

  def system_info_options(options)
    %W(
      --formats human,json
      --human-output #{options.fetch(:dest_dir)}/system_info
      --json-output #{options.fetch(:dest_dir)}/system_info.json
      --commands-file #{options.fetch(:commands_file)}
      --cookbooks-sha #{options.fetch(:cookbooks_sha)}
    )
  end

  def try_become_user(user)
    uid = Etc.getpwnam(user).uid

    begin
      Process::Sys.seteuid(uid)
      Process::Sys.setuid(uid)
    rescue Errno::EPERM => e
      warn e
    end
  end
end

Chef::Recipe.send(:include, SystemInfoRecipeMethods)
