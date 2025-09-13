require 'json'
require 'open-uri'
require 'fileutils'
require 'digest'
require 'net/https'
require 'net/http'

module TravisJava
  module OpenJDKOpenJ9
    def install_openjdk_openj9(version)
      attribute_key = "openjdk" + version.to_s + "-openj9"
      java_home = ::File.join(node['travis_java']['jvm_base_dir'], node['travis_java'][attribute_key]['jvm_name'])
      pinned_release = node['travis_java'][attribute_key]['pinned_release']
      # arch = node['travis_java']['arch']
      arch = "x64_Linux" if node['travis_java']['arch'] == "amd64"
      arch = "ppc64le_Linux" if node['travis_java']['arch'] == "ppc64el"
      url = ::File.join("https://api.adoptopenjdk.net", attribute_key, "releases", arch, "latest")

      # Obtain the uri of the latest IBM Java build for the specified version from index.yml
      if pinned_release
        url = ::File.join("https://api.adoptopenjdk.net", attribute_key, "releases", arch)
        entry = find_version_entry(url, pinned_release)
      else
        entry = find_version_entry(url, version)
      end

      # Download and install the IBM Java build
      install_build(entry, java_home, version)

      # Delete IBM Java installable and installer properties file
      delete_files(version)

      link_cacerts(java_home, version)
    end

    # This method downloads and installs the java build
    # @param [Hash] entry - latest entry from the index.yml for the specified ibm java version containing uri
    # @param [String] java_home - directory path where OpenJDK build will be installed
    # @param [String] version - java version
    # @return - None

    def install_build(entry, java_home, version)
      binary = File.join(Dir.tmpdir, "openjdk" + version.to_s + "_openj9.tgz")
      # Download the Openjdk build from source url to the local machine
      remote_file binary do
        src_url = entry['uri']
        source src_url.to_s
        mode '0755'
        checksum entry['sha256sum']
        action :create
        notifies :run, "ruby_block[Verify Checksum of #{binary} file]", :immediately
      end

      # Verify Checksum of the downloaded IBM Java build
      ruby_block "Verify Checksum of #{binary} file" do
        block do
          checksum = Digest::SHA256.hexdigest(File.read(binary))
          expected_checksum = entry['sha256sum']
          if checksum != expected_checksum
            raise "Checksum of the downloaded OpendJDK build #{checksum} does not match the #{expected_checksum}"
          end
        end
        action :nothing
      end

      execute "Remove old java build installed at #{java_home}" do
        command "rm -rf #{java_home}"
        action :run
      end

      # Extract the OpenJDK build
      execute "Extract OpenJDK#{version} build" do
        command "tar -zxf #{binary}"
        action :run
      end

      execute "Move the OpenJDK#{version} build to #{java_home} dir" do
        command "mv ./#{entry['release']} #{java_home}"
        action :run
      end
    end

    def link_cacerts(java_home, version)
      link "#{java_home}/jre/lib/security/cacerts" do
        to '/etc/ssl/certs/java/cacerts'
        not_if { version > 8 }
      end

      link "#{java_home}/lib/security/cacerts" do
        to '/etc/ssl/certs/java/cacerts'
        not_if { version <= 8 }
      end
    end

    # This method deletes the IBM Java installable and installer properties files
    # @param [String] version - java version
    # @return - None

    def delete_files(version)
      binary = File.join(Dir.tmpdir, "openjdk" + version.to_s + "_openj9" + ".tgz")

      file binary do
        action :delete
      end
    end

    def find_version_entry(url, version)
      binary = []
      release = version
      json = open(url.to_s, &:read)
      parsed = JSON.parse(json, object_class: JSON::GenericObject)
      case parsed
      when Array
        release = parsed[0]["release_name"] if version.to_s == "8"
        binary = find_binary(parsed, release)
      when Object
        release = parsed["release_name"] if version.to_s == "8"
        binary = parsed["binaries"][0] if parsed["release_name"].to_s == release.to_s
      end
      fill_entry(binary, release)
    end

    def fill_entry(binary, release)
      entry = {}
      entry["uri"] = binary["binary_link"]
      content = open(binary["checksum_link"].to_s, &:read)
      array = content.split(" ")
      entry["sha256sum"] = array[0]
      entry["release"] = release
      entry
    end

    def find_binary(parsed, release)
      binary = []
      (0..parsed.count - 1).each do |i|
        if parsed[i]["release_name"].to_s == release.to_s
          binary = parsed[i]["binaries"][0]
          break
        end
      end
      binary
    end
  end
end
