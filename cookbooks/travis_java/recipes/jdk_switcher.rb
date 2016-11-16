directory '/opt/jdk_switcher' do
  owner 'root'
  group 'root'
  mode 0o755
  recursive true
end

remote_file '/opt/jdk_switcher/jdk_switcher.sh' do
  source node['travis_java']['jdk_switcher_url']
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o644
end

link ::File.join(node['travis_build_environment']['home'], '.jdk_switcher_rc') do
  to '/opt/jdk_switcher/jdk_switcher.sh'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end
