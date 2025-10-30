# frozen_string_literal: true

remote_file "#{Chef::Config[:file_cache_path]}/get-pip3.py" do
  source 'https://bootstrap.pypa.io/get-pip.py'
  mode '644'
  not_if 'which pip3'
end
bash 'install-pip3' do
  cwd Chef::Config[:file_cache_path]
  code <<-INSTALL_PIP3
  python3 get-pip.py
  python3 -m pip install pip setuptools wheel pytest nose
  INSTALL_PIP3
  not_if 'which pip3'
end
