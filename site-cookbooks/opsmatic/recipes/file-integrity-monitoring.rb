# This recipe will enable File Integrity monitoring for user specified files
# https://opsmatic.com/app/docs/file-integrity-monitoring
# Include an array of files paths within your attributes

# Create /var/db/opsmatic-agent/external.d/

directory '/var/db/opsmatic-agent/external.d' do
  owner 'root'
  group 'root'
  mode '00644'
end

# Populate the directory created above with a JSON file:

# Create JSON file from attributes (array of comma separated paths)
# i.e  "file-monitor-list": ['/etc/nginx/nginx.conf','/etc/ssh/sshd_config','/etc/rsyslog.conf','/etc/hosts','/etc/passwd']

template '/var/db/opsmatic-agent/external.d/file-integrity-monitoring.json' do
  source 'file-integrity-monitoring.json.erb'
  owner 'root'
  group 'root'
  mode '00644'
end
