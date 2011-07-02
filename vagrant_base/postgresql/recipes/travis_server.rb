include_recipe "server_debian"

bash "create user" do
  user "postgres"
  code "createuser --no-password --no-superuser --createdb --no-createrole vagrant"

  # a very lame way to make sure 2nd and other runs do not fail.
  # the proper way is to simply use a .sql script to set up users. MK.
  ignore_failure true
end
