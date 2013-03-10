action :install do
  new_resource = @new_resource
  extension    = new_resource.extension
  versions     = new_resource.versions

  new_resource.before_recipes.each do |recipe|
    @run_context.include_recipe recipe
  end

  new_resource.before_packages.each do |pkg|
    package pkg do
      action :install
    end
  end

  bash "before installing PECL extension #{extension} script" do
    user    "root"
    cwd     "/tmp"
    code    new_resource.before_script
    only_if do
      new_resource.before_script && !new_resource.before_script.empty?
    end
  end

  versions.each do |php_version|
    if new_resource.script && !new_resource.script.empty?
      bash "manually install PECL extension #{extension} for PHP #{php_version}" do
        user        new_resource.owner
        group       new_resource.group
        cwd         "/tmp"
        environment Hash["HOME" => node.travis_build_environment.home]
        code        <<-EOF
          source /etc/profile.d/phpenv.sh
          phpenv global #{php_version}
          #{new_resource.script}
        EOF
      end
    else
      bash "install PECL extension #{extension} for PHP #{php_version}" do
        user        new_resource.owner
        group       new_resource.group
        environment Hash["HOME" => node.travis_build_environment.home]
        code        <<-EOF
          source /etc/profile.d/phpenv.sh
          phpenv global #{php_version}

          if [ ! -z "#{new_resource.channel}" ]; then
            pear channel-discover #{new_resource.channel}
          fi

          pecl info #{extension}
          return=$?
          if [ $return = 0 ] || [ -f "$(pecl config-get ext_dir)/#{extension}.so" ]; then
            echo "Extension #{extension} was already installed for PHP #{php_version}."
          elif [ $return = 1 ]; then
            result=$(pecl install #{extension} | tail -1)
            if [[ "$result" =~ ^ERROR: ]]; then
              echo "There was an error installing extension #{extension} for PHP #{php_version}:"
              echo "$result"
              exit 1
            fi
            echo "Extension #{extension} successfully installed for PHP #{php_version}."
          else
            echo "There was an error installing extension #{extension} for PHP #{php_version}."
            exit 1
          fi
        EOF
      end
    end
  end
end

action :uninstall do
  new_resource = @new_resource
  extension    = new_resource.extension
  versions     = new_resource.versions

  versions.each do |php_version|
    bash "uninstall PECL extension #{extension} for PHP #{php_version}" do
      user  new_resource.owner
      group new_resource.group
      code  <<-EOF
      pecl uninstall #{extension}
      EOF
    end
  end
end
