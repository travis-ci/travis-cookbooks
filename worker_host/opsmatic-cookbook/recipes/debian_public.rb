# opsmatic::debian_public
#  Installs and configures opsmatic public debian repo

apt_repository 'opsmatic_public' do
  uri 'https://packagecloud.io/opsmatic/public/any/'
  distribution 'any'
  components ['main']
  key "D59097AB.key"
end
