module RsyslogCookbook
  # helpers for the various service providers on Ubuntu systems
  module Helpers
    def declare_rsyslog_service
      if node['platform'] == 'ubuntu' && node['platform_version'].to_f >= 12.04
        service_provider = Chef::Provider::Service::Upstart
      else
        service_provider = nil
      end

      service node['rsyslog']['service_name'] do
        supports :restart => true, :status => true
        action   [:enable, :start]
        provider service_provider
      end
    end
  end
end
