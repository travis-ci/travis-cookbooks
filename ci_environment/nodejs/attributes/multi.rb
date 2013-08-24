default[:nodejs][:default]  = '0.10.12'
default[:nodejs][:others]   = nil

if node[:nodejs][:others].is_a?(Array)
  default[:nodejs][:versions] = node[:nodejs][:others].insert(0, node[:nodejs][:default]).uniq
else
  default[:nodejs][:versions] = [ node[:nodejs][:default] ]
end

node[:nodejs][:versions].each do |nv| 
  default[:nodejs][:aliases][nv] = nv[/\d+\.\d+/]
end

