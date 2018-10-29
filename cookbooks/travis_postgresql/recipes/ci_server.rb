# frozen_string_literal: true

create_superusers_script = ::File.join(
  Chef::Config[:file_cache_path],
  'postgresql_create_superusers.sql'
)

if !node['travis_postgresql']['superusers'].to_a.empty? && !::File.exist?(create_superusers_script)
  service 'postgresql' do
    action :start
  end

  template create_superusers_script do
    source 'create_superusers.sql.erb'
    owner 'postgres'
  end

  Range.new(
    node['travis_postgresql']['port'],
    node['travis_postgresql']['port'] + node['travis_postgresql']['alternate_versions'].length
  ).each do |pg_port|
    execute 'Execute SQL script to create additional superusers' do
      command "psql --port=#{pg_port} --file=#{create_superusers_script}"
      user 'postgres'
    end
  end
end

service 'postgresql' do
  action %i[disable stop]
end

template '/etc/init.d/postgresql' do
  source 'initd_postgresql.erb'
  owner 'root'
  group 'root'
  mode 0o755
end

file '/lib/systemd/system/postgresql.service' do
  action :delete
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
  only_if { node['lsb']['codename'] == 'xenial' }
end

execute 'systemctl daemon-reload' do
  action :nothing
  only_if { node['lsb']['codename'] == 'xenial' }
end

TravisPostgresqlMethods.pg_versions(node).each do |pg_version|
  template "/etc/postgresql/#{pg_version}/main/postgresql.conf" do
    source "#{pg_version}/postgresql.conf.erb"
    owner 'postgres'
    group 'postgres'
    mode 0o644 # apply same permissions as in 'pdpg' packages
  end

  template "/etc/postgresql/#{pg_version}/main/pg_hba.conf" do
    source 'pg_hba.conf.erb'
    owner 'postgres'
    group 'postgres'
    mode 0o640 # apply same permissions as in 'pdpg' packages
  end
end
