# frozen_string_literal: true

# Cookbook Name:: travis_sbt_extras
# Recipe:: default
#
# Copyright 2012-2013, Gilles Cornu
# Copyright 2017 Travis CI GmbH
#

if node['travis_java']['default_version'] =~ /jdk/
  include_recipe 'travis_java'
elsif node['travis_jdk']['default_version'] =~ /jdk/
  include_recipe 'travis_jdk'
end

script_absolute_path = File.join(
  node['travis_sbt_extras']['setup_dir'],
  node['travis_sbt_extras']['script_name']
)

tmp_project_dir = File.join(
  Chef::Config[:file_cache_path],
  'setup-sbt-extras-tmp-project'
)

#
# Download sbt-extras script (so far without checksum verification, for easy and lazy updates)
#
remote_file script_absolute_path do
  source node['travis_sbt_extras']['download_url']
  backup false
  mode 0o755
  owner node['travis_sbt_extras']['owner']
  group node['travis_sbt_extras']['group']
end

#
# Install default config files
#
directory node['travis_sbt_extras']['config_dir'] do
  owner node['travis_sbt_extras']['owner']
  group node['travis_sbt_extras']['group']
  mode 0o755
end

jvmopts_path = if node['travis_sbt_extras']['jvmopts']['filename'].to_s.empty?
                 ''
               else
                 File.join(
                   node['travis_sbt_extras']['config_dir'],
                   node['travis_sbt_extras']['jvmopts']['filename']
                 )
               end

template jvmopts_path do
  source 'jvmopts.erb'
  owner node['travis_sbt_extras']['owner']
  group node['travis_sbt_extras']['group']
  mode 0o644
  not_if { jvmopts_path.empty? }
end

sbtopts_path = if node['travis_sbt_extras']['sbtopts']['filename'].to_s.empty?
                 ''
               else
                 File.join(
                   node['travis_sbt_extras']['config_dir'],
                   node['travis_sbt_extras']['sbtopts']['filename']
                 )
               end

template sbtopts_path do
  source 'sbtopts.erb'
  owner node['travis_sbt_extras']['owner']
  group node['travis_sbt_extras']['group']
  mode 0o644
  not_if { sbtopts_path.empty? }
end

template "/etc/profile.d/#{node['travis_sbt_extras']['script_name']}.sh" do
  source 'profile_sbt.sh.erb'
  owner node['travis_sbt_extras']['owner']
  group node['travis_sbt_extras']['group']
  mode 0o640

  variables(
    jvmopts: jvmopts_path,
    sbtopts: sbtopts_path
  )

  only_if do
    node['travis_sbt_extras']['system_wide_defaults'] && (
      File.exist?(jvmopts_path) || File.exist?(sbtopts_path)
    )
  end
end

#
# Optionally download sbt launchers and pre-install dependencies in user environments
# Note: There is no idempotence condition, since sbt is itself idempotent.
#
if node['travis_sbt_extras']['user_setup']
  node['travis_sbt_extras']['user_setup'].keys.each do |sbt_user|
    node['travis_sbt_extras']['user_setup'][sbt_user]['sbt'].each do |sbt_version|
      node['travis_sbt_extras']['user_setup'][sbt_user]['scala'].each do |scala_version|
        directory File.join(tmp_project_dir, 'project') do
          recursive true
          owner sbt_user
        end

        # Workaround to new behavior of '-sbt-create' that always considers the project to be based on current sbt release
        file File.join(tmp_project_dir, 'project', 'build.properties') do
          content "sbt.version=#{sbt_version}"
          owner sbt_user
        end

        execute "running sbt-extras as user #{sbt_user} to pre-install scala #{scala_version} with sbt #{sbt_version}" do
          command "#{script_absolute_path} -scala-version #{scala_version} about"
          user sbt_user
          cwd tmp_project_dir

          environment(
            'HOME' => File.join(node['travis_sbt_extras']['user_home_basedir'], sbt_user)
          )
        end

        directory tmp_project_dir do
          action :delete
          recursive true
        end
      end
    end
  end
end
