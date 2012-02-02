node.set[:sphinx][:versions] = {
  '1.10-beta' => '/usr/local'
}

include_recipe 'sphinx::install'
