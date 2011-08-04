node.set[:sphinx][:versions] = {
  '2.0.1-beta' => '/usr/local/sphinx-2.0.1',
  '1.10-beta'  => '/usr/local/sphinx-1.10',
  '0.9.9'      => '/usr/local/sphinx-0.9.9'
}

include_recipe 'sphinx::install'

%w( indexer indextool search searchd spelldump ).each do |binary|
  link "/usr/local/bin/#{binary}" do
    to "/usr/local/sphinx-2.0.1/bin/#{binary}"
  end
end
