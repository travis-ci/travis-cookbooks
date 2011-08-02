package "libmysql++-dev" do
  action :install
end

package "postgresql-client" do
  action :install
end

package "libpq-dev" do
  action :install
end


directory '/tmp/sphinx_install' do
  mode '0755'
  action :create
end

remote_file "/tmp/sphinx_install/sphinx-1.10.tar.gz" do
  source "http://www.sphinxsearch.com/files/sphinx-1.10-beta.tar.gz"
  mode "0644"
  action :create_if_missing
end

execute "untar sphinx archive" do
  command "tar xvfz sphinx-1.10.tar.gz"
  cwd "/tmp/sphinx_install"
end

execute "Download libstemmer" do
  command 'curl -O http://snowball.tartarus.org/dist/libstemmer_c.tgz'
  cwd '/tmp/sphinx_install/sphinx-1.10'
end

execute "Untar libstemmer" do
  command 'tar zxvf libstemmer_c.tgz'
  cwd '/tmp/sphinx_install/sphinx-1.10'
end

execute './configure --with-mysql --with-pgsql --with-libstemmer --prefix=/usr/local/sphinx-1.10 && make && make install' do
  cwd '/tmp/sphinx_install/sphinx-1.10'
end
