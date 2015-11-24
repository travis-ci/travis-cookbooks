actions :install, :uninstall

attribute :extension,       :kind_of => String, :name_attribute => true
attribute :channel,         :kind_of => String
attribute :versions,        :kind_of => Array
attribute :before_recipes,  :kind_of => Array,  :default => []
attribute :before_packages, :kind_of => Array,  :default => []
attribute :before_script,   :kind_of => String
attribute :script,          :kind_of => String
attribute :owner,           :regex => Chef::Config[:user_valid_regex]
attribute :group,           :regex => Chef::Config[:group_valid_regex]
