if node['lsb']['codename'] == 'precise'
  include_attribute 'memcached::default'
  default['memcached']['sasl'] = false
end
