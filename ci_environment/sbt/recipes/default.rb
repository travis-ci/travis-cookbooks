#
# Cookbook Name:: sbt-extras
# Recipe:: default
#
# Copyright 2012-2013, Gilles Cornu
#

include_recipe "java"

script_absolute_path = File.join(node['sbt-extras']['setup_dir'], node['sbt-extras']['script_name'])
tmp_project_dir = File.join(Chef::Config[:file_cache_path], 'setup-sbt-extras-tmp-project')

#
# Download sbt-extras script (so far without checksum verification, for easy and lazy updates)
#
remote_file script_absolute_path do
  source node['sbt-extras']['download_url']
  backup false
  mode   '0755'
  owner  node['sbt-extras']['owner']
  group  node['sbt-extras']['group']
end

#
# Install default config files
#
directory node['sbt-extras']['config_dir'] do
  owner node['sbt-extras']['owner']
  group node['sbt-extras']['group']
  mode '0755'
end

jvmopts_path = node['sbt-extras']['jvmopts']['filename'].to_s.empty? ? '' : File.join(node['sbt-extras']['config_dir'], node['sbt-extras']['jvmopts']['filename'])
template jvmopts_path do
  source 'jvmopts.erb'
  owner  node['sbt-extras']['owner']
  group  node['sbt-extras']['group']
  mode   '0644'
  not_if do jvmopts_path.empty? end
end

sbtopts_path = node['sbt-extras']['sbtopts']['filename'].to_s.empty? ? '' : File.join(node['sbt-extras']['config_dir'], node['sbt-extras']['sbtopts']['filename'])
template sbtopts_path do
  source 'sbtopts.erb'
  owner  node['sbt-extras']['owner']
  group  node['sbt-extras']['group']
  mode   '0644'
  not_if do sbtopts_path.empty? end
end

template "#{File.join('/etc/profile.d', node['sbt-extras']['script_name'])}.sh" do
  source 'profile_sbt.sh.erb'
  owner  node['sbt-extras']['owner']
  group  node['sbt-extras']['group']
  mode   '0640'                      # SBT_OPTS and JVM_OPTS environment variables only should be set for sbt users
  variables({
    :jvmopts => jvmopts_path,
    :sbtopts => sbtopts_path
  })
  only_if do
    node['sbt-extras']['system_wide_defaults'] && (File.exists?(jvmopts_path) || File.exists?(sbtopts_path))
  end
end

#
# Optionally download sbt launchers and pre-install dependencies in user environments
# Note: There is no idempotence condition, since sbt is itself idempotent.
#
if node['sbt-extras']['user_setup']
  node['sbt-extras']['user_setup'].keys.each do |sbt_user|
    node['sbt-extras']['user_setup'][sbt_user]['sbt'].each do |sbt_version|
      node['sbt-extras']['user_setup'][sbt_user]['scala'].each do |scala_version|
        directory File.join(tmp_project_dir, 'project') do
          recursive true
          owner     sbt_user
        end
        # Workaround to new behavior of '-sbt-create' that always considers the project to be based on current sbt release
        file File.join(tmp_project_dir, 'project', 'build.properties') do
          content "sbt.version=#{sbt_version}"
          owner   sbt_user
        end
        execute "running sbt-extras as user #{sbt_user} to pre-install scala #{scala_version} with sbt #{sbt_version}" do

          # ATTENTION: current command only supports sbt 0.11+. See Issues #9 and #10 (won't be fixed).
          command "#{script_absolute_path} -scala-version #{scala_version} about"
          user    sbt_user
          cwd     tmp_project_dir

          # ATTENTION: chef-execute switch to user, but keep original environment variables (e.g. HOME=/root)
          environment ({ 'HOME' => File.join(node['sbt-extras']['user_home_basedir'], sbt_user) })
        end
        directory tmp_project_dir do
          action :delete
          recursive true
        end
      end
    end
  end
end
