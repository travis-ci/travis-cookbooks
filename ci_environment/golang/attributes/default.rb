# can be "stable" or "tip"
default['golang']['version'] = "stable"

default['golang']['multi']['default_version'] = "go1.4"
default['golang']['multi']['versions']        = [node['golang']['multi']['default_version']]
default['golang']['multi']['aliases']         = {}

# enable multi-versions by adding more versions, like in example below:
#default['golang']['multi']['versions']        = ["go1.0.3", "go1.1.2", "go1.2.2", "go1.3.3", node['golang']['multi']['default_version']]
#default['golang']['multi']['aliases']         = {"go1" => "go1.0.3", "go1.0" => "go1.0.3", "go1.1" => "go1.1.2", "go1.2" => "go1.2.2", "go1.3" => "go1.3.3"}
