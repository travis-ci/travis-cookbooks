module GitCookbook
  module Helpers
    # linux packages default to distro offering
    def parsed_package_name
      return new_resource.package_name if new_resource.package_name
      return 'git-core' if node['platform'] == 'ubuntu' && node['platform_version'].to_f < 10.10
      return 'developer/versioning/git' if node['platform'] == 'omnios'
      return 'scmgit' if node['platform'] == 'smartos'
      'git'
    end

    def parsed_package_version
      return new_resource.package_version if new_resource.package_version
    end

    # source
    def parsed_source_url
      return new_resource.source_url if new_resource.source_url
      "https://nodeload.github.com/git/git/tar.gz/v#{new_resource.source_version}"
    end

    def parsed_source_checksum
      return new_resource.source_checksum if new_resource.source_checksum
      '8d53703d75890c03e26a915c7af3b7b98d8cfb94382f685a9bcbee1eeaec47b4' # 2.7.4 tarball
    end

    # windows
    def parsed_windows_display_name
      return new_resource.windows_display_name if new_resource.windows_display_name
      "Git version #{parsed_windows_package_version}"
    end

    def parsed_windows_package_version
      return new_resource.windows_package_version if new_resource.windows_package_version
      '2.7.4'
    end

    def parsed_windows_package_url
      return new_resource.windows_package_url if new_resource.windows_package_url
      "https://github.com/git-for-windows/git/releases/download/v%#{parsed_windows_package_version}.windows.1/Git-%#{parsed_windows_package_version}-32-bit.exe"
    end

    def parsed_windows_package_checksum
      return new_resource.windows_package_checksum if new_resource.windows_package_checksum
      '49601d5102df249d6f866ecfa1eea68eb5672acc1dbb7e4051099e792f6da5fc'
    end
  end
end
