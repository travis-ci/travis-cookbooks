#
# Author:: Mevan Samaratunga (<mevansam@gmail.com>)
# Author:: Michael Goetz (<mpgoetz@gmail.com>)
# Cookbook:: java-libraries
# Provider:: certificate
#
# Copyright:: 2013, Mevan Samaratunga
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'digest/sha2'
require 'openssl'
require 'fileutils'

class Chef::Provider::JavaCertificate < Chef::Provider::LWRPBase
  include Chef::Mixin::ShellOut

  use_inline_resources

  action :install do
    directory(Chef::Config[:file_cache_path]).to_s

    java_home = new_resource.java_home
    java_home = node['java']['java_home'] if java_home.nil?
    keytool = "#{java_home}/bin/keytool"

    truststore = new_resource.keystore_path
    truststore_passwd = new_resource.keystore_passwd

    truststore = "#{node['java']['java_home']}/jre/lib/security/cacerts" if truststore.nil?
    truststore_passwd = 'changeit' if truststore_passwd.nil?

    certalias = new_resource.cert_alias
    certalias = new_resource.name if certalias.nil?

    certdata = new_resource.cert_data
    certdatafile = new_resource.cert_file
    certendpoint = new_resource.ssl_endpoint

    if certdata.nil?

      if !certdatafile.nil?

        certdata = IO.read(certdatafile)

      elsif !certendpoint.nil?

        cmd = Mixlib::ShellOut.new("echo QUIT | openssl s_client -showcerts -connect #{certendpoint}")
        cmd.run_command
        Chef::Log.debug(cmd.format_for_exception)

        Chef::Application.fatal!("Error returned when attempting to retrieve certificate from remote endpoint #{certendpoint}: #{cmd.exitstatus}", cmd.exitstatus) unless cmd.exitstatus == 0

        certout = cmd.stdout.split(/-----BEGIN CERTIFICATE-----|-----END CERTIFICATE-----/)
        if certout.size > 2 && !certout[1].empty?
          certdata = "-----BEGIN CERTIFICATE-----#{certout[1]}-----END CERTIFICATE-----"
        else
          Chef::Application.fatal!("Unable to parse certificate from openssl query of #{certendpoint}.", 999)
        end
      else
        Chef::Application.fatal!('At least one of cert_data, cert_file or ssl_endpoint attributes must be provided.', 999)
      end
    end

    hash = Digest::SHA512.hexdigest(certdata)
    certfile = "#{Chef::Config[:file_cache_path]}/#{certalias}.cert.#{hash}"
    cmd = Mixlib::ShellOut.new("#{keytool} -list -keystore #{truststore} -storepass #{truststore_passwd} -rfc -alias \"#{certalias}\"")
    cmd.run_command
    keystore_cert = cmd.stdout.match(/^[-]+BEGIN.*END(\s|\w)+[-]+$/m).to_s

    keystore_cert_digest = if keystore_cert.empty?
                             nil
                           else
                             Digest::SHA512.hexdigest(OpenSSL::X509::Certificate.new(keystore_cert).to_der)
                           end
    certfile_digest = Digest::SHA512.hexdigest(OpenSSL::X509::Certificate.new(certdata).to_der)
    if keystore_cert_digest == certfile_digest
      Chef::Log.debug("Certificate \"#{certalias}\" in keystore \"#{truststore}\" is up-to-date.")
    else

      cmd = Mixlib::ShellOut.new("#{keytool} -list -keystore #{truststore} -storepass #{truststore_passwd} -v")
      cmd.run_command
      Chef::Log.debug(cmd.format_for_exception)
      Chef::Application.fatal!("Error querying keystore for existing certificate: #{cmd.exitstatus}", cmd.exitstatus) unless cmd.exitstatus == 0

      has_key = !cmd.stdout[/Alias name: #{certalias}/].nil?

      if has_key

        cmd = Mixlib::ShellOut.new("#{keytool} -delete -alias \"#{certalias}\" -keystore #{truststore} -storepass #{truststore_passwd}")
        cmd.run_command
        Chef::Log.debug(cmd.format_for_exception)
        unless cmd.exitstatus == 0
          Chef::Application.fatal!("Error deleting existing certificate \"#{certalias}\" in " \
              "keystore so it can be updated: #{cmd.exitstatus}", cmd.exitstatus)
        end
      end

      ::File.open(certfile, 'w', 0o644) { |f| f.write(certdata) }

      cmd = Mixlib::ShellOut.new("#{keytool} -import -trustcacerts -alias \"#{certalias}\" -file #{certfile} -keystore #{truststore} -storepass #{truststore_passwd} -noprompt")
      cmd.run_command
      Chef::Log.debug(cmd.format_for_exception)

      unless cmd.exitstatus == 0

        FileUtils.rm_f(certfile)
        Chef::Application.fatal!("Error importing certificate into keystore: #{cmd.exitstatus}", cmd.exitstatus)
      end

      Chef::Log.debug("Sucessfully imported certificate \"#{certalias}\" to keystore \"#{truststore}\".")
    end
  end

  action :remove do
    directory(Chef::Config[:file_cache_path]).to_s

    certalias = new_resource.name

    truststore = new_resource.keystore_path
    truststore_passwd = new_resource.keystore_passwd

    truststore = "#{node['java']['java_home']}/jre/lib/security/cacerts" if truststore.nil?
    truststore_passwd = 'changeit' if truststore_passwd.nil?

    keytool = "#{node['java']['java_home']}/bin/keytool"

    cmd = Mixlib::ShellOut.new("#{keytool} -list -keystore #{truststore} -storepass #{truststore_passwd} -v | grep \"#{certalias}\"")
    cmd.run_command
    has_key = !cmd.stdout[/Alias name: #{certalias}/].nil?
    Chef::Application.fatal!("Error querying keystore for existing certificate: #{cmd.exitstatus}", cmd.exitstatus) unless cmd.exitstatus == 0

    if has_key

      cmd = Mixlib::ShellOut.new("#{keytool} -delete -alias \"#{certalias}\" -keystore #{truststore} -storepass #{truststore_passwd}")
      cmd.run_command
      unless cmd.exitstatus == 0
        Chef::Application.fatal!("Error deleting existing certificate \"#{certalias}\" in " \
            "keystore so it can be updated: #{cmd.exitstatus}", cmd.exitstatus)
      end
    end

    FileUtils.rm_f("#{Chef::Config[:file_cache_path]}/#{certalias}.cert.*")
  end
end
