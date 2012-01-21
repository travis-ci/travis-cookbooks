actions :create, :delete

attribute :version, :name_attribute => true, :kind_of => String
attribute :owner, :regex => Chef::Config[:user_valid_regex]
attribute :group, :regex => Chef::Config[:group_valid_regex]
