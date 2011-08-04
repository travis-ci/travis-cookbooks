node.set[:sphinx][:versions] = {
  '0.9.9' => '/usr/local'
}

include_recipe 'sphinx::install'
