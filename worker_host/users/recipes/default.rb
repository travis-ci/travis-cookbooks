node[:users].each do |user_name, home|
  user user_name do
    shell "/bin/zsh" 
    home home
  end
end
