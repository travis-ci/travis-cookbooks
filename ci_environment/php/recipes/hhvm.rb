include_recipe "hhvm"

phpenv_path = "#{node.travis_build_environment.home}/.phpenv"
hhvm_path   = "#{phpenv_path}/versions/hhvm"

directory "#{hhvm_path}/bin" do
  owner     node.travis_build_environment.user
  group     node.travis_build_environment.group
  action    :create
  recursive true
end

file "#{hhvm_path}/bin/php" do
  owner  node.travis_build_environment.user
  group  node.travis_build_environment.group
  mode   00755
  content <<-CONTENT
#!/usr/bin/env bash
hhvm "$@"
  CONTENT
end
