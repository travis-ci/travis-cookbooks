# frozen_string_literal: true

# Cookbook:: travis_jdk
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright:: 2018, Travis CI GmbH
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Skrypt install_jdk.sh nie obsługuje architektury ppc64le
return if node['kernel']['machine'] == 'ppc64le'

# Funkcja do generowania argumentów dla skryptu install-jdk.sh
def install_jdk_args(jdk)
  m = jdk.match(/(?<vendor>[a-z]+)-?(?<version>.+)?/)
  if m[:vendor].start_with? 'oracle'
    license = 'BCL'
  elsif m[:vendor].start_with? 'openjdk'
    license = 'GPL'
  else
    puts 'Houston is calling: Nieznany dostawca JDK!'
    license = 'UNKNOWN'
  end
  "--feature #{m[:version]} --license #{license}"
end

# Lista wersji JDK do zainstalowania
versions = [
  node['travis_jdk']['default'],
  node['travis_jdk']['versions'],
].flatten.compact.uniq

# Kopiowanie skryptu install-jdk.sh do /usr/local/bin
cookbook_file '/usr/local/bin/install-jdk.sh' do
  source 'install-jdk.sh'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  sensitive true
end

# Aktualizacja listy pakietów APT
apt_update 'update_sources' do
  action :update
end

# Instalacja pakietu default-jre
apt_package 'default_java' do
  package_name %w(default-jre)
  action :install
end

# Instalacja poszczególnych wersji JDK
versions.each do |jdk|
  next if jdk.nil?

  args = install_jdk_args(jdk)
  cache = "#{Chef::Config[:file_cache_path]}/#{jdk}"
  target = ::File.join(
    node['travis_jdk']['destination_path'],
    jdk
  )
  # Dodanie opcji --cacerts dla licencji GPL
  cacerts = '--cacerts' if args =~ /GPL/

  bash "Install #{jdk} #{args} #{target} #{cache} #{cacerts}" do
    # Użycie heredoc do lepszej czytelności i obsługi wieloliniowego kodu
    code <<-EOH
      echo "===== Instalacja JDK #{jdk} ====="
      echo "Parametry: #{args} --target #{target} --workspace #{cache} #{cacerts}"
      set -x
      /usr/local/bin/install-jdk.sh #{args} --target #{target} --workspace #{cache} #{cacerts}
      set +x
    EOH
    # Włączenie streamowania outputu do logów Chef
    live_stream true
    # Opcjonalnie, możesz dodać retry lub inne atrybuty
    retries 3
    retry_delay 5
  end
end

# Dołączenie recipe dla profilu bash użytkownika travis
include_recipe 'travis_build_environment::bash_profile_d'

# Generowanie pliku konfiguracyjnego bash_profile.d/travis_jdk.bash
template ::File.join(
  node['travis_build_environment']['home'],
  '.bash_profile.d/travis_jdk.bash'
) do
  source 'travis_jdk.bash.erb'
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode '0644'
  variables(
    jdk: node['travis_jdk']['default'],
    path: node['travis_jdk']['destination_path'],
    docker: node['virtualization']['system'] == 'docker'
  )
end
