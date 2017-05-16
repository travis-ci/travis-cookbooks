#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
# Cookbook:: git
# Attributes:: default
#
# Copyright:: 2008-2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

case node['platform_family']
when 'windows'
  default['git']['version'] = '2.8.1'
  if node['kernel']['machine'] == 'x86_64'
    default['git']['architecture'] = '64'
    default['git']['checksum'] = '5e5283990cc91d1e9bd0858f8411e7d0afb70ce26e23680252fb4869288c7cfb'
  else
    default['git']['architecture'] = '32'
    default['git']['checksum'] = '17418c2e507243b9c98db161e9e5e8041d958b93ce6078530569b8edaec6b8a4'
  end
  default['git']['url'] = 'https://github.com/git-for-windows/git/releases/download/v%{version}.windows.1/Git-%{version}-%{architecture}-bit.exe'
  default['git']['display_name'] = "Git version #{node['git']['version']}"
when 'mac_os_x'
  default['git']['osx_dmg']['app_name']    = 'git-2.8.1-intel-universal-mavericks'
  default['git']['osx_dmg']['volumes_dir'] = 'Git 2.8.1 Mavericks Intel Universal'
  default['git']['osx_dmg']['package_id']  = 'GitOSX.Installer.git281Universal.git.pkg'
  default['git']['osx_dmg']['url']         = 'http://sourceforge.net/projects/git-osx-installer/files/git-2.8.1-intel-universal-mavericks.dmg/download'
  default['git']['osx_dmg']['checksum']    = 'c2912895a1e2018d9be4c646765d511f7c82e0114275505dbd13d1ac70c62023'
else
  default['git']['prefix'] = '/usr/local'
  default['git']['version'] = '2.8.1'
  default['git']['url'] = 'https://nodeload.github.com/git/git/tar.gz/v%{version}'
  default['git']['checksum'] = 'e08503ecaf5d3ac10c40f22871c996a392256c8d038d16f52ebf974cba29ae42'
  default['git']['use_pcre'] = false
end

default['git']['server']['base_path'] = '/srv/git'
default['git']['server']['export_all'] = true
