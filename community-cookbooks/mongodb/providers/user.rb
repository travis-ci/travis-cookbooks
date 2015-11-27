def user_exists?(username, connection)
  connection['admin']['system.users'].find(:user => username).count > 0
end

def add_user(username, password, roles = [], database)
  require 'rubygems'
  require 'mongo'

  connection = retrieve_db
  admin = connection.db('admin')
  db = connection.db(database)

  # Check if user is admin / admin, and warn that this should
  # be overridden to unique values
  if username == 'admin' && password == 'admin'
    Chef::Log.warn('Default username / password detected for admin user');
    Chef::Log.warn('These should be overridden to different, unique values');
  end

  # If authentication is required on database
  # must authenticate as a userAdmin after an admin user has been created
  # this will fail on the first attempt, but user will still be created
  # because of the localhost exception
  if node['mongodb']['config']['auth'] == true
    begin
      admin.authenticate(@new_resource.connection['admin']['username'], @new_resource.connection['admin']['password'])
    rescue Mongo::AuthenticationError => e
      Chef::Log.warn("Unable to authenticate as admin user. If this is a fresh install, ignore warning: #{e}")
    end
  end

  # Create the user if they don't exist
  # Update the user if they already exist
  db.add_user(username, password, false, :roles => roles)
  Chef::Log.info("Created or updated user #{username} on #{database}")
end

# Drop a user from the database specified
def delete_user(username, database)
  require 'rubygems'
  require 'mongo'

  connection = retrieve_db
  admin = connection.db('admin')
  db = connection.db(database)

  admin.authenticate(@new_resource.connection['admin']['username'], @new_resource.connection['admin']['password'])

  if user_exists?(username, connection)
    db.remove_user(username)
    Chef::Log.info("Deleted user #{username} on #{database}")
  else
    Chef::Log.warn("Unable to delete non-existent user #{username} on #{database}")
  end
end

# Get the MongoClient connection
def retrieve_db
  require 'rubygems'
  require 'mongo'

  Mongo::MongoClient.new(
    @new_resource.connection['host'],
    @new_resource.connection['port'],
    :connect_timeout => 15,
    :slave_ok => true
  )
end

action :add do
  add_user(new_resource.username, new_resource.password, new_resource.roles, new_resource.database)
end

action :delete do
  delete_user(new_resource.username, new_resource.database)
end

action :modify do
  add_user(new_resource.username, new_resource.password, new_resource.roles, new_resource.database)
end
