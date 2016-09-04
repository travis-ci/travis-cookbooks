if defined?(ChefSpec)
  def create_rsyslog_file_input(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rsyslog_file_input, :create, resource_name)
  end
end
