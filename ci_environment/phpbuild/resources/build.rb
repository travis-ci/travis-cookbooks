actions :create, :delete

attribute :path, :kind_of => String, :name_attribute => true
attribute :version, :default => "5.3.8"
attribute :owner, :regex => Chef::Config[:user_valid_regex]
attribute :group, :regex => Chef::Config[:group_valid_regex]
