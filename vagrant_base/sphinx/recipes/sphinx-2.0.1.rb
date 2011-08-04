node.set[:sphinx][:versions] = {
  '2.0.1-beta' => '/usr/local'
}

include_recipe 'sphinx::install'
