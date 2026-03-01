# frozen_string_literal: true

require 'yaml'
require 'open-uri'
require 'fileutils'
require 'digest'

module TravisJava
  module IBMJava
    def install_ibmjava(version)
      attribute_key = "ibmjava" + version.to_s
      java_home = ::File.join(node['travis_java']['jvm_base_dir'], node['travis_java'][attribute_key]['jvm_name'])
      pinned_release = node['travis_java'][attribute_key]['pinned_release']
      arch = node['travis_java']['arch']
      arch = "x86_64" if arch == "amd64"
      index_yml = ::File.join("https://public.dhe.ibm.com/ibmdl/export/pub/systems/cloud/runtimes/java/meta/sdk",
                              node['travis_java']['ibmjava']['platform'], arch, "index.yml")

      # Obtain the uri of the latest IBM Java build for the specified version from index.yml
      if pinned_release
        entry = find_version_entry(index_yml, pinned_release)
      else
        entry = find_version_entry(index_yml, version)
      end

      # Download and install the IBM Java build
      install_build(entry, java_home, version)

      # Delete IBM Java installable and installer properties file
      delete_files(version)

      link_cacerts(java_home, version)
    end

    # This method downloads and installs the java build
    # @param [Hash] entry - latest entry from the index.yml for the specified ibm java version containing uri
    # @param [String] java_home - directory path where IBM Java will be installed
    # @param [String] version - java version
    # @return - None

    def install_build(entry, java_home, version)
      installer = File.join(Dir.tmpdir, "ibmjava" + version.to_s + "-installer")
      properties = File.join(Dir.tmpdir, "installer.properties")
      expected_checksum = entry['sha256sum']

      # Download the IBM Java installer from source url to the local machine
      remote_file installer do
        src_url = entry['uri']
        source src_url.to_s
        mode '0755'
        checksum entry['sha256sum']
        action :create
        notifies :run, "ruby_block[Verify Checksum of #{installer} file]", :immediately
      end

      # Verify Checksum of the downloaded IBM Java build
      ruby_block "Verify Checksum of #{installer} file" do
        block do
          checksum = Digest::SHA256.hexdigest(File.read(installer))
          if checksum != expected_checksum
            raise "Checksum of the downloaded IBM Java build #{checksum} does not match the expected checksum #{expected_checksum}"
          end
        end
        action :nothing
      end

      # Create installer properties for silent installation
      file "Create installer properties file for IBM Java#{version}" do
        path properties
        content "INSTALLER_UI=silent\nUSER_INSTALL_DIR=#{java_home}\nLICENSE_ACCEPTED=TRUE\n"
        action :create
      end

      # Install IBM Java build
      execute "Install IBM Java#{version} build" do
        command "#{installer} -i silent -f #{properties}"
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
      installer = File.join(Dir.tmpdir, "ibmjava" + version.to_s + "-installer")
      properties = File.join(Dir.tmpdir, "installer.properties")
      file "Delete properties file for IBM Java#{version}" do
        path properties
        action :delete
      end

      file installer do
        action :delete
      end
    end

    # This method returns a hash containing the uri and checksum of the latest release by parsing the index.yml file
    # @param [String] url - url of index.yml file
    # @param [String] version - java version
    # @return [Hash] finalversion - latest entry from the index.yml for the specified IBM Java version containing uri
    #                               and sha256sum
    def find_version_entry(url, version)
      finalversion = nil
      version = '1.'.concat(version.to_s) unless version.to_s.include?('.')
      yaml_content = open(url.to_s, &:read)
      entries = YAML.safe_load(yaml_content)
      entries.each do |entry|
        finalversion = entry[1] if entry[0].to_s.start_with?(version.to_s)
      end
      finalversion
    end
  end
end
