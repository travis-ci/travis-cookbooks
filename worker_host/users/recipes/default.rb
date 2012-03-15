node[:users].each do |user_name, data|
  user user_name do
    shell data[:shell]
    home data[:home]
  end

  if data[:ssh_keys]
    directory "#{data[:home]}/.ssh" do
      mode "0700"
      owner user_name
    end

    template "#{data[:home]}/.ssh/authorized_keys" do
      mode "0600"
      source "authorized_keys.pub"
      variables :ssh_keys => data[:ssh_keys]
    end
  end
end
