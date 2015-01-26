default[:nodejs][:default]  = "0.10.36"
default[:nodejs][:versions] = [ node[:nodejs][:default] ]
default[:nodejs][:aliases]  = { node[:nodejs][:default] => node[:nodejs][:default][/\d+\.\d+/] }
default[:nodejs][:default_modules] = [
  { :module => 'grunt-cli', :required => '0.8' }
]
