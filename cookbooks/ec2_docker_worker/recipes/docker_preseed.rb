service 'docker' do
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end

bash 'zomg wait for docker' do
  code 'start docker ; docker version'
  retries node[:ec2_docker_worker][:docker][:restart_retries]
  retry_delay node[:ec2_docker_worker][:docker][:restart_retry_delay]
end

node[:ec2_docker_worker][:docker][:languages].each do |lang|
  execute "docker pull quay.io/travisci/travis-#{lang}:latest"
  execute "docker tag quay.io/travisci/travis-#{lang}:latest travis:#{lang}"
end
