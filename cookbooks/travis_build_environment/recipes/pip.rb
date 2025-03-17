# frozen_string_literal: true

case node['lsb']['codename']
when 'xenial', 'bionic'
  # Install pip for Python 2
  remote_file "#{Chef::Config[:file_cache_path]}/get-pip.py" do
    source 'https://bootstrap.pypa.io/pip/2.7/get-pip.py'
    mode '644'
    not_if 'which pip'
  end
  bash 'install-pip2' do
    cwd Chef::Config[:file_cache_path]
    code <<-INSTALL_PIP
      python get-pip.py
      pip install --upgrade pip setuptools wheel
    INSTALL_PIP
    not_if 'which pip'
  end

  # Install pip3 for Python 3
  remote_file "#{Chef::Config[:file_cache_path]}/get-pip3.py" do
    source 'https://bootstrap.pypa.io/get-pip.py'
    mode '644'
    not_if 'which pip3'
  end
  bash 'install-pip3' do
    cwd Chef::Config[:file_cache_path]
    code <<-INSTALL_PIP3
      python3 get-pip.py
      pip3 install --upgrade pip setuptools wheel
    INSTALL_PIP3
    not_if 'which pip3'
  end
# Noble doesn't like pip install, packages need to be installed by apt install
when 'focal', 'jammy'
  remote_file "#{Chef::Config[:file_cache_path]}/get-pip.py" do
    source 'https://bootstrap.pypa.io/get-pip.py'
    mode '644'
    not_if 'which pip3'
  end
  bash 'install-pip3' do
    cwd Chef::Config[:file_cache_path]
    code <<-INSTALL_PIP3
      python3 get-pip.py
      pip3 install --upgrade pip setuptools wheel
    INSTALL_PIP3
    not_if 'which pip3'
  end
end
