#
# Cookbook Name:: openssh
# Attributes:: default
#
# Author:: Ernie Brodeur <ebrodeur@ujami.net>
# Copyright 2008-2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Attributes are commented out using the default config file values.
# Uncomment the ones you need, or set attributes in a role.
#

default['openssh']['package_name'] = case node['platform_family']
                                     when 'rhel', 'fedora'
                                       %w(openssh-clients openssh-server)
                                     when 'arch', 'suse', 'gentoo'
                                       %w(openssh)
                                     when 'freebsd', 'smartos'
                                       %w()
                                     else
                                       %w(openssh-client openssh-server)
                                     end

default['openssh']['service_name'] = case node['platform_family']
                                     when 'rhel', 'fedora', 'suse', 'freebsd', 'gentoo', 'arch'
                                       'sshd'
                                     else
                                       'ssh'
                                     end

default['openssh']['config_mode'] = case node['platform_family']
                                    when 'rhel', 'fedora'
                                      '0600'
                                    else
                                      '0644'
                                    end

# ssh config group
default['openssh']['client']['host'] = '*'

# Workaround for CVE-2016-0777 and CVE-2016-0778.
# Older versions of RHEL should not receive this directive
default['openssh']['client']['use_roaming'] = 'no' unless node['platform_family'] == 'rhel' && node['platform_version'].to_i < 7
# default['openssh']['client']['forward_agent'] = 'no'
# default['openssh']['client']['forward_x11'] = 'no'
# default['openssh']['client']['rhosts_rsa_authentication'] = 'no'
# default['openssh']['client']['rsa_authentication'] = 'yes'
# default['openssh']['client']['password_authentication'] = 'yes'
# default['openssh']['client']['host_based_authentication'] = 'no'
# default['openssh']['client']['gssapi_authentication'] = 'no'
# default['openssh']['client']['gssapi_delegate_credentials'] = 'no'
# default['openssh']['client']['batch_mode'] = 'no'
# default['openssh']['client']['check_host_ip'] = 'yes'
# default['openssh']['client']['address_family'] = 'any'
# default['openssh']['client']['connect_timeout'] = '0'
# default['openssh']['client']['strict_host_key_checking'] = 'ask'
# default['openssh']['client']['identity_file'] = '~/.ssh/identity'
# default['openssh']['client']['identity_file_rsa'] = '~/.ssh/id_rsa'
# default['openssh']['client']['identity_file_dsa'] = '~/.ssh/id_dsa'
# default['openssh']['client']['port'] = '22'
# default['openssh']['client']['protocol'] = [ '2 1' ]
# default['openssh']['client']['cipher'] = '3des'
# default['openssh']['client']['ciphers'] = [ 'aes128-ctr aes192-ctr aes256-ctr arcfour256 arcfour128 aes128-cbc 3des-cbc' ]
# default['openssh']['client']['macs'] = [ 'hmac-md5 hmac-sha1 umac-64@openssh.com hmac-ripemd160' ]
# default['openssh']['client']['escape_char'] = '~'
# default['openssh']['client']['tunnel'] = 'no'
# default['openssh']['client']['tunnel_device'] = 'any:any'
# default['openssh']['client']['permit_local_command'] = 'no'
# default['openssh']['client']['visual_host_key'] = 'no'
# default['openssh']['client']['proxy_command'] = 'ssh -q -W %h:%p gateway.example.com'
# sshd config group
# default['openssh']['server']['port'] = '22'
# default['openssh']['server']['address_family'] = 'any'
# default['openssh']['server']['listen_address'] = [ '0.0.0.0 ::' ]
# default['openssh']['server']['protocol'] = '2'
# default['openssh']['server']['host_key_v1'] = '/etc/ssh/ssh_host_key'
# default['openssh']['server']['host_key_rsa'] = '/etc/ssh/ssh_host_rsa_key'
# default['openssh']['server']['host_key_dsa'] = '/etc/ssh/ssh_host_dsa_key'
if platform_family?('smartos')
  default['openssh']['server']['host_key'] = ['/var/ssh/ssh_host_rsa_key', '/var/ssh/ssh_host_dsa_key']
end
# default['openssh']['server']['host_key_ecdsa'] = '/etc/ssh/ssh_host_ecdsa_key'
# default['openssh']['server']['key_regeneration_interval'] = '1h'
# default['openssh']['server']['server_key_bits'] = '1024'
# default['openssh']['server']['syslog_facility'] = 'AUTH'
# default['openssh']['server']['log_level'] = 'INFO'
# default['openssh']['server']['login_grace_time'] = '2m'
# default['openssh']['server']['permit_root_login'] = 'yes'
# default['openssh']['server']['strict_modes'] = 'yes'
# default['openssh']['server']['max_auth_tries'] = '6'
# default['openssh']['server']['max_sessions'] = '10'
# default['openssh']['server']['r_s_a_authentication'] = 'yes'
# default['openssh']['server']['pubkey_authentication'] = 'yes'
# default['openssh']['server']['authorized_keys_file'] = '%h/.ssh/authorized_keys'
# default['openssh']['server']['rhosts_r_s_a_authentication'] = 'no'
# default['openssh']['server']['host_based_authentication'] = 'no'
# default['openssh']['server']['ignore_user_known_hosts'] = 'no'
# default['openssh']['server']['ignore_rhosts'] = 'yes'
# default['openssh']['server']['password_authentication'] = 'yes'
# default['openssh']['server']['permit_empty_passwords'] = 'no'
default['openssh']['server']['challenge_response_authentication'] = 'no'
# default['openssh']['server']['kerberos_authentication'] = 'no'
# default['openssh']['server']['kerberos_or_localpasswd'] = 'yes'
# default['openssh']['server']['kerberos_ticket_cleanup'] = 'yes'
# default['openssh']['server']['kerberos_get_afs_token'] = 'no'
# default['openssh']['server']['gssapi_authentication'] = 'no'
# default['openssh']['server']['gssapi_clean_up_credentials'] = 'yes'
default['openssh']['server']['use_p_a_m'] = 'yes' unless platform_family?('smartos')
# default['openssh']['server']['allow_agent_forwarding'] = 'yes'
# default['openssh']['server']['allow_tcp_forwarding'] = 'yes'
# default['openssh']['server']['gateway_ports'] = 'no'
# default['openssh']['server']['x11_forwarding'] = 'no'
# default['openssh']['server']['x11_display_offset'] = '10'
# default['openssh']['server']['x11_use_localhost'] = 'yes'
# default['openssh']['server']['print_motd'] = 'yes'
# default['openssh']['server']['print_last_log'] = 'yes'
# default['openssh']['server']['t_c_p_keep_alive'] = 'yes'
# default['openssh']['server']['use_login'] = 'no'
# default['openssh']['server']['use_privilege_separation'] = 'yes'
# default['openssh']['server']['permit_user_environment'] = 'no'
# default['openssh']['server']['compression'] = 'delayed'
# default['openssh']['server']['client_alive_interval'] = '0'
# default['openssh']['server']['client_alive_count_max'] = '3'
# default['openssh']['server']['use_dns'] = 'yes'
# default['openssh']['server']['pid_file'] = '/var/run/sshd.pid'
# default['openssh']['server']['max_startups'] = '10'
# default['openssh']['server']['permit_tunnel'] = 'no'
# default['openssh']['server']['chroot_directory'] = 'none'
# default['openssh']['server']['banner'] = 'none'
# default['openssh']['server']['subsystem'] = 'sftp /usr/libexec/sftp-server'
default['openssh']['server']['match'] = {}
