# frozen_string_literal: true

remote_file "#{Chef::Config[:file_cache_path]}/get-pip.py" do
  source 'https://bootstrap.pypa.io/get-pip.py'
  mode '644'
  not_if 'which pip'
end

bash 'install-pip3' do
  cwd Chef::Config[:file_cache_path]
  code <<-INSTALL_PIP
    python3 get-pip.py
    pip3 install --upgrade pip setuptools wheel
  INSTALL_PIP
  not_if 'which pip'
end
