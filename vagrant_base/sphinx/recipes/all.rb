node.set[:sphinx][:versions] = {
  '2.0.1-beta' => '/usr/local',
  '1.10-beta'  => '/usr/local/sphinx-1.10',
  '0.9.9'      => '/usr/local/sphinx-0.9.9'
}

include_recipe 'sphinx::install'
