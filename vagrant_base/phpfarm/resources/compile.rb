actions :create, :delete

attribute :version, :default => "5.3.8", :name_attribute => true
attribute :owner, :regex => Chef::Config[:user_valid_regex]
attribute :group, :regex => Chef::Config[:group_valid_regex]
