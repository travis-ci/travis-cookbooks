class Chef
  class Provider
    class GitClient < Chef::Provider::LWRPBase
      include GitCookbook::Helpers
    end
  end
end
