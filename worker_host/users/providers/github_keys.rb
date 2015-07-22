action :create do
  ruby_block "add keys for #{new_resource.id}" do
    block do
      new_resource.updated_by_last_action(add_github_keys(new_resource))
    end
  end
end

def whyrun_supported?
  false
end

def add_github_keys(new_resource)
  authorized_keys_file = "/home/#{new_resource.id}/.ssh/authorized_keys"
  return false if ::File.size?(authorized_keys_file)

  response = fetch_keys(new_resource.github_username)
  return false if response.code > '299'

  write_keys(authorized_keys_file, new_resource.github_username, response.body)
  fix_perms(authorized_keys_file, new_resource.id)
  true
end

def fetch_keys(github_username)
  require 'net/http'
  require 'openssl'

  http = Net::HTTP.new('github.com', 443)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  http.request(Net::HTTP::Get.new("/#{github_username}.keys"))
end

def write_keys(authorized_keys_file, github_username, keys)
  ::File.open(authorized_keys_file, 'w') do |f|
    f.puts <<-EOF.gsub(/^\s+> /, '')
      > # keys pulled from github for #{github_username}
      > #{keys}
    EOF
  end
end

def fix_perms(authorized_keys_file, user_id)
  require 'fileutils'

  FileUtils.chmod(0600, authorized_keys_file)
  FileUtils.chown(user_id, user_id, authorized_keys_file)
end
