# opsmatic::rhel_public
#  Installs and configures opsmatic public yum repo
#  loosely cribbed from https://github.com/computology/packagecloud-cookbook/blob/6f6d303ee22daddb8473182f5fc1d588087c879c/providers/repo.rb
#  to avoid having a bunch of dependencies in the cookbook

cookbook_file "/etc/pki/rpm-gpg/RPM-GPG-KEY-opsmatic_packagecloud" do
  source 'packagecloud_yum_gpg.key'
end

cookbook_file "/etc/yum.repos.d/opsmatic_public.repo" do
  source 'yum_opsmatic_public.repo'
  mode '0644'
  notifies :run, "execute[yum-makecache-opsmatic_public]", :immediately
  notifies :create, "ruby_block[yum-cache-reload-opsmatic_public]", :immediately
end

# get the metadata for this repo only
execute "yum-makecache-opsmatic_public" do
  command "yum -q makecache -y --disablerepo=* --enablerepo=opsmatic_public"
  action :nothing
end

# reload internal Chef yum cache
ruby_block "yum-cache-reload-opsmatic_public" do
  block { Chef::Provider::Package::Yum::YumCache.instance.reload }
  action :nothing
end
