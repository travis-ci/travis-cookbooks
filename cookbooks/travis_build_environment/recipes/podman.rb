# Cookbook:: podman
# Recipe:: default

apt_repository 'podman_repo' do
    uri          node['podman']['repo_uri']
    distribution node['podman']['distribution']
    components   node['podman']['components']
    key          node['podman']['repo_key']
    action :add
  end
  
  apt_update 'update' do
    action :update
  end
  
  package 'podman' do
    version node['podman']['version']
    action :install
  end
