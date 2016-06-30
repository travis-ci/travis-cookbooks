include_recipe "tmate_proxy::elixir"

directory "#{node[:tmate_proxy][:app_path]}/running-config" do
  recursive true
end

# for edeliver and our failure to name our app properly
link "#{node[:tmate_proxy][:app_path]}/tmate" do
  to '.'
end

template "#{node[:tmate_proxy][:app_path]}/running-config/vm.args" do
  source 'vm.args.erb'
  owner 'root'
  mode '0644'
end

git node[:tmate_proxy][:src_path] do
  repository "https://github.com/tmate-io/tmate-proxy.git"
  revision 'master'
  action :sync
  notifies :create, "template[#{node[:tmate_proxy][:src_path]}/config/prod.exs]", :immediately
  notifies :run, "bash[compile tmate_proxy]", :immediately
end

template "#{node[:tmate_proxy][:src_path]}/config/prod.exs" do
  source 'prod.exs.erb'
  owner 'root'
  mode '0644'
  variables config: MixConfigHelper.render_config(node[:tmate_proxy][:config])
  action :nothing
end

bash "compile tmate_proxy" do
  cwd node[:tmate_proxy][:src_path]
  environment "LC_ALL"   => "en_US.UTF-8",
              "LANG"     => "en_US.UTF-8",
              "LANGUAGE" => "en_US.UTF-8",
              "MIX_ENV"  => "prod"
  code "mix local.hex --force && mix local.rebar --force && mix deps.get && mix release"
  action :nothing
  notifies :run, "bash[install tmate_proxy]", :immediately
end

bash "install tmate_proxy" do
  cwd node[:tmate_proxy][:app_path]
  code "tar xf #{node[:tmate_proxy][:src_path]}/rel/tmate/releases/*/tmate.tar.gz"
end

template '/etc/init/tmate-proxy.conf' do
  source 'tmate-proxy.conf.erb'
  owner 'root'
  mode '0644'
  variables app_path: node[:tmate_proxy][:app_path]
end

service "tmate-proxy" do
  provider Chef::Provider::Service::Upstart
  action [:enable]
end
