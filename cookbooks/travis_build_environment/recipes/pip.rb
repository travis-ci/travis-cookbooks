# frozen_string_literal: true

remote_file "#{Chef::Config[:file_cache_path]}/get-pip.py" do
  source 'https://bootstrap.pypa.io/get-pip.py'
  mode 0o644
  not_if 'which pip'
end

bash 'install-pip' do
  cwd Chef::Config[:file_cache_path]
  code <<-INSTALL_PIP
    python get-pip.py
    pip install --upgrade pip setuptools wheel
  INSTALL_PIP
  not_if 'which pip'
end
