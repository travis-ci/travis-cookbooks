node.php.multi.phps.each do |php_version|
  phpfarm_phpfarm php_version do
    owner "vagrant"
    group "vagrant"

    action :create
  end
end
