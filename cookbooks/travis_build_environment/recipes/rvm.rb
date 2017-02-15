gpg_key_path = ::File.join(
  Chef::Config[:file_cache_path], 'mpapis.asc'
)
rvm_installer_path = ::File.join(
  Chef::Config[:file_cache_path], 'rvm-installer'
)
rvmrc_path = ::File.join(
  node['travis_build_environment']['home'], '.rvmrc'
)
rvmrc_content = Array(
  node['travis_build_environment']['rvmrc_env']
).map { |k, v| "#{k}='#{v}'" }.join("\n")
rvm_script_path = ::File.join(
  node['travis_build_environment']['home'], '.rvm', 'bin', 'rvm'
)
global_gems = Array(
  node['travis_build_environment']['global_gems']
).map { |g| g[:name] }.join(' ')

bash 'import mpapis.asc' do
  code "gpg2 --import #{gpg_key_path}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment('HOME' => node['travis_build_environment']['home'])
  action :nothing
end

remote_file gpg_key_path do
  source 'https://rvm.io/mpapis.asc'
  checksum '6ba1ebe6b02841db9ea3b73b85d4ede87192584efc7dfe13fe42a29416767ffa'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o644
  notifies :run, 'bash[import mpapis.asc]', :immediately
end

remote_file rvm_installer_path do
  source 'https://get.rvm.io'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
end

bash 'run rvm installer' do
  code "#{rvm_installer_path} stable"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  creates ::File.join(
    node['travis_build_environment']['home'],
    '.rvm', 'VERSION'
  )
  environment('HOME' => node['travis_build_environment']['home'])
end

file rvmrc_path do
  content rvmrc_content
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o644
end

bash "install default ruby #{node['travis_build_environment']['default_ruby']}" do
  code "#{rvm_script_path} install #{node['travis_build_environment']['default_ruby']} --binary --fuzzy --autolibs=3"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment('HOME' => node['travis_build_environment']['home'])
  not_if { node['travis_build_environment']['default_ruby'].to_s.empty? }
end

bash "create default alias for #{node['travis_build_environment']['default_ruby']}" do
  code "#{rvm_script_path} alias create default #{node['travis_build_environment']['default_ruby']}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment('HOME' => node['travis_build_environment']['home'])
  not_if { node['travis_build_environment']['default_ruby'].to_s.empty? }
end

bash 'install global gems' do
  code "#{rvm_script_path} @global do gem install #{global_gems}"
  user node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  environment('HOME' => node['travis_build_environment']['home'])
end

Array(node['travis_build_environment']['rubies']).each do |ruby_def|
  bash "install ruby #{ruby_def}" do
    code "#{rvm_script_path} use #{ruby_def} --install --binary --fuzzy --autolibs=3"
    user node['travis_build_environment']['user']
    group node['travis_build_environment']['group']
    environment('HOME' => node['travis_build_environment']['home'])
  end
end
