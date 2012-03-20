users = search(:users)

users.each do |user|
  user user[:id] do
    shell user[:shell]
    home user[:home]
  end

  if user[:ssh_key]
    directory "#{user[:home]}/.ssh" do
      mode "0700"
      owner user[:id]
    end

    template "#{user[:home]}/.ssh/authorized_keys" do
      mode "0600"
      source "authorized_keys.pub"
      variables :ssh_key => user[:ssh_key]
    end
  end
end
