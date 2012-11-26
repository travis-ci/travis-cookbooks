#
# Cookbook Name:: sbt-extras
# Recipe:: default
#
# Copyright 2012, Gilles Cornu
#

include_recipe "java"

script_absolute_path = File.join(node['sbt-extras']['setup_dir'], node['sbt-extras']['script_name'])
tmp_project_dir = File.join(Chef::Config[:file_cache_path], 'setup-sbt-extras-tmp-project')

# Create (or modify) the group of sbt-extras power users (allowed to install new versions of sbt)
group node['sbt-extras']['group'] do
  members node['sbt-extras']['group_new_members']
  append true # add new members, if the group already exists
end

directory File.join(node['sbt-extras']['setup_dir'], '.lib') do
  recursive true
  owner node['sbt-extras']['owner']
  group node['sbt-extras']['group']
  mode '2775' # enable 'setgid' flag to force group ID inheritance on sub-elements
end

# Download sbt-extras script
remote_file script_absolute_path do
  source node['sbt-extras']['download_url']
  backup false
  mode   '0755'
  owner  node['sbt-extras']['owner']
  group  node['sbt-extras']['group']
end

# Optionally create a symlink (typically to be part of default PATH, example: /usr/bin/sbt)
link node['sbt-extras']['bin_symlink'] do
  to     script_absolute_path
  owner  node['sbt-extras']['owner']
  group  node['sbt-extras']['group']
  not_if { node['sbt-extras']['bin_symlink'].nil? }
end

# Install default config files
directory node['sbt-extras']['config_dir'] do
  owner node['sbt-extras']['owner']
  group node['sbt-extras']['group']
  mode '0755'
end
template File.join(node['sbt-extras']['config_dir'], node['sbt-extras']['sbtopts_filename'])  do
  source "sbtopts.erb"
  owner  node['sbt-extras']['owner']
  group  node['sbt-extras']['group']
  mode   '0664'
  variables(
    :arg_mem => node['sbt-extras']['sbtopts']['mem']
  )
end
template File.join(node['sbt-extras']['config_dir'], node['sbt-extras']['jvmopts_filename']) do
  source "jvmopts.erb"
  owner  node['sbt-extras']['owner']
  group  node['sbt-extras']['group']
  mode   '0664'
  not_if do 
    node['sbt-extras']['jvmopts_filename'].empty?
  end
end

# Start sbt, to force download and setup of default sbt-laucher
unless File.directory?(File.join(node['sbt-extras']['setup_dir'], '.lib', node['sbt-extras']['default_sbt_version'])) 
  directory tmp_project_dir do
    # Create a very-temporary folder to store dummy project files, created by '-sbt-create' arg
    mode '0777'
  end
  execute "Forcing sbt-extras to install its default sbt version" do
    command "#{script_absolute_path} -mem #{node['sbt-extras']['sbtopts']['mem']} -batch -sbt-create"
    user    node['sbt-extras']['owner']
    group   node['sbt-extras']['group'] 
    umask   '002' # grant write permission to group.
    cwd     tmp_project_dir
    timeout node['sbt-extras']['preinstall_cmd']['timeout']
    # ATTENTION: chef-execute switch to user, but keep original environment variables (e.g.  HOME=/root)
    environment ( { 'HOME' => tmp_project_dir } ) # .sbt/.ivy2 files won't be kept.
  end
  directory tmp_project_dir do
    action :delete
    recursive true
  end
end

# Optionally download and pre-install libraries of sbt version-matrix in user own environment
if node['sbt-extras']['preinstall_matrix']
  node['sbt-extras']['preinstall_matrix'].keys.each do |sbt_user|
    node['sbt-extras']['preinstall_matrix'][sbt_user].each do |sbt_version|
      unless File.directory?(File.join(node['sbt-extras']['user_home_basedir'], sbt_user, '.sbt', sbt_version)) 
        directory tmp_project_dir do
          # Create a very-temporary folder to store dummy project files, created by '-sbt-create' arg
          mode '0777'
        end
        execute "running sbt-extras as user #{sbt_user} to pre-install libraries of sbt #{sbt_version}" do

          # ATTENTION: current command only supports sbt 0.11+. See Issues #9 and #10.
          command "#{script_absolute_path} -mem #{node['sbt-extras']['sbtopts']['mem']} -batch -sbt-version #{sbt_version} -sbt-create"
          user    sbt_user
          group   node['sbt-extras']['group']
          umask   '002'   # grant write permission to group.
          cwd     tmp_project_dir
          timeout node['sbt-extras']['preinstall_cmd']['timeout']

          # ATTENTION: chef-execute switch to user, but keep original environment variables (e.g.  HOME=/root)
          environment ( { 'HOME' => File.join(node['sbt-extras']['user_home_basedir'], sbt_user) } )          
        end
        directory tmp_project_dir do
          action :delete
          recursive true
        end
      end
    end
  end
end
