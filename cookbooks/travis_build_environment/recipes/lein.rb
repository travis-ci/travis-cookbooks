remote_file '/usr/local/bin/lein' do
  source node['travis_build_environment']['lein_url']
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
end

execute 'lein self-install' do
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
end
