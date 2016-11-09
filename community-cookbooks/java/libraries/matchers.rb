if defined?(ChefSpec)
  def set_java_alternatives(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:java_alternatives, :set, resource_name)
  end

   def unset_java_alternatives(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:java_alternatives, :set, resource_name)
  end

  def install_java_ark(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:java_ark, :install, resource_name)
  end

  def remove_java_ark(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:java_ark, :remove, resource_name)
  end
end
