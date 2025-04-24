# frozen_string_literal: true

# Cookbook:: travis_system_info
# Recipe:: default
#
# Copyright:: 2017 Travis CI GmbH
#
# MIT License
#
local_gem = "#{Chef::Config[:file_cache_path]}/system-info.gem"

remote_file local_gem do
  source node['travis_system_info']['gem_url']
  checksum node['travis_system_info']['gem_sha256sum']
end

execute "/opt/chef/embedded/bin/gem install -b #{local_gem.inspect}"

execute "rm -rf #{node['travis_system_info']['dest_dir']}"

directory node['travis_system_info']['dest_dir'] do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  recursive true
end

ruby_block 'generate system-info report' do
  block do
    require 'net/http'
    require 'uri'
    require 'open3'

    uri = URI.parse('http://localhost:9200')
    max_tries = 5
    tries = 0

    begin
      tries += 1
      res = Net::HTTP.start(uri.host, uri.port) { |http| http.head('/') }

      if res.is_a?(Net::HTTPSuccess) || res.is_a?(Net::HTTPRedirection)
        Chef::Log.info("✅ Elasticsearch available: #{res.code} #{res.message}")
      else
        raise "Unexpected HTTP code from Elasticsearch: #{res.code}"
      end

    rescue StandardError => e
      if tries < max_tries
        Chef::Log.warn("Elasticsearch not available (#{e}), retrying in 10s… (#{tries}/#{max_tries})")
        sleep 10
        retry
      else
        Chef::Log.error("❌ Elasticsearch still unavailable after #{max_tries} attempts: #{e}")
        status_out, status_err, status_status = Open3.capture3('systemctl', 'status', 'elasticsearch.service')
        Chef::Log.error("--- systemctl status elasticsearch.service ---\n#{status_out}\n#{status_err}")
        journal_out, journal_err, journal_status = Open3.capture3('journalctl', '-xe', '-u', 'elasticsearch.service', '--no-pager', '--since', '1 hour ago')
        Chef::Log.error("--- journalctl -xe (last hour) ---\n#{journal_out}\n#{journal_err}")
        # raise if you want to abort Chef run
      end
    end

    exec = Chef::Resource::Execute.new('system-info report', run_context)
    exec.command(
      SystemInfoMethods.system_info_command(
        user:          node['travis_build_environment']['user'],
        dest_dir:      node['travis_system_info']['dest_dir'],
        commands_file: node['travis_system_info']['commands_file'],
        cookbooks_sha: node['travis_system_info']['cookbooks_sha']
      )
    )
    exec.environment('HOME' => node['travis_build_environment']['home'])
    exec.run_action(:run)
  end
  action :run
end
