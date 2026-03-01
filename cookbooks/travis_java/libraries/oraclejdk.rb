# frozen_string_literal: true

module TravisJava
  module OracleJdk
    def install_oraclejdk(version)
      attribute_key = "oraclejdk#{version}"
      pkg_prefix = "oracle-java#{version}"
      pkg_installer = "#{pkg_prefix}-installer"
      deb_installer = ::File.join(
        Chef::Config[:file_cache_path],
        "#{pkg_installer}.deb"
      )
      installer_cache_path = "/var/cache/oracle-jdk#{version}-installer"
      java_home = ::File.join(
        node['travis_java']['jvm_base_dir'],
        node['travis_java'][attribute_key]['jvm_name']
      )

      include_recipe 'travis_java::webupd8'

      # accept Oracle License v1.1, otherwise the package won't install
      bash "accept oracle license v1.1 for #{attribute_key}" do
        code <<-EOBASH.gsub(/^\s+>\s/, '')
          > /bin/echo -e #{pkg_installer} shared/accepted-oracle-license-v1-1 select true | \\
          >   debconf-set-selections
        EOBASH
      end

      pinned_release = node['travis_java'][attribute_key]['pinned_release']
      if pinned_release
        remote_file deb_installer do
          source ::File.join(
            'http://ppa.launchpad.net/webupd8team/java/ubuntu/pool/main/o',
            pkg_installer,
            "#{pkg_installer}_#{pinned_release}.deb"
          )
          not_if "test -f #{deb_installer}"
        end

        dpkg_package deb_installer
      else
        package pkg_installer
      end

      package "#{pkg_prefix}-unlimited-jce-policy"

      link "#{java_home}/jre/lib/security/cacerts" do
        to '/etc/ssl/certs/java/cacerts'
        not_if { version > 8 }
        # TODO: This "skip condition" must be removed when the Oracle JDK 9
        # package will provide the 'jre' subdirectory
        # TODO: Check to see if the 'jre' subdirectory is provided yet :-P
      end

      directory installer_cache_path do
        action :delete
        recursive true
      end
    end
  end
end
