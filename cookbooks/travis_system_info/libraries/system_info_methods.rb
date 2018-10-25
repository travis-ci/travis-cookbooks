# frozen_string_literal: true

module SystemInfoMethods
  class << self
    def system_info_command(options = {})
      "#{system_info_exe} report #{system_info_options(options)}"
    end

    private

    def system_info_exe
      '/opt/chef/embedded/bin/system-info'
    end

    def system_info_options(options)
      options_array = %W[
        --formats human,json
        --human-output #{options.fetch(:dest_dir)}/system_info
        --json-output #{options.fetch(:dest_dir)}/system_info.json
        --cookbooks-sha #{options.fetch(:cookbooks_sha)}
      ]

      commands_file = options.fetch(:commands_file, '')
      unless commands_file.nil? || commands_file.empty?
        options_array << "--commands-file #{options.fetch(:commands_file)}"
      end

      options_array.join(' ')
    end
  end
end
