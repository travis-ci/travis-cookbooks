#dst = "C:\\Users\\Vagrant\\Downloads\\npp.exe"
#remote_file dst do
#    source "http://download.tuxfamily.org/notepadplus/6.2.3/npp.6.2.3.Installer.exe"
#    not_if { File.exists?(dst) }
#end

#execute "install Notepad++" do
#    command "#{dst} /S"
#end

windows_package "Notepad++" do
    source "http://download.tuxfamily.org/notepadplus/6.2.3/npp.6.2.3.Installer.exe"
    action :install
end
