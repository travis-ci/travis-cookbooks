vsn = "2.5.1"

default[:leiningen] = {
  :version        => vsn,
  :install_script => "https://raw.github.com/technomancy/leiningen/#{vsn}/bin/lein",
  :home           => "/home/vagrant",
  :user           => "vagrant",
  :bin_path       => "/usr/local/bin/lein"
}
