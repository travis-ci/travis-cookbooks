directory "/dev/shm" do
  recursive true
  action :delete
  not_if { File.symlink?("/dev/shm") }
end

link "/dev/shm" do
  to "/run/shm"
  not_if { File.symlink?("/dev/shm") }
end