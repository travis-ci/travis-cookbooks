default[:kestrel] = {
  :tarball => {
    :url       => "http://robey.github.com/kestrel/download/kestrel-2.3.2.zip",
    :directory => "kestrel-2.3.2"
  },
  :installation_dir => "/usr/local/kestrel",
  :log_dir          => "/var/log/kestrel/",
  :config_dir       => "/etc/kestrel/",
  :user             => "kestrel",
  :group            => "kestrel",
  :limits => {
    :memlock => 'unlimited',
    :nofile  => 48000
  },
}
