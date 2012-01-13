package 'libmysql++-dev' do
  action :install
end

include_recipe "postgresql::client"

script 'download libstemmer once' do
  interpreter 'bash'
  code <<-SHELL
    mkdir -p /tmp/sphinx_install
    cd /tmp/sphinx_install
    wget http://snowball.tartarus.org/dist/libstemmer_c.tgz
  SHELL
end

node.sphinx.versions.each do |version, path|
  log("Installing Sphinx #{version} to #{path}") { level :debug }

  script 'install sphinx with libstemmer' do
    interpreter 'bash'
    code <<-SHELL
      cd /tmp/sphinx_install
      wget http://www.sphinxsearch.com/files/sphinx-#{version}.tar.gz
      tar zxvf sphinx-#{version}.tar.gz
      cp libstemmer_c.tgz sphinx-#{version}/libstemmer_c.tgz
      cd sphinx-#{version}
      tar zxvf libstemmer_c.tgz
      ./configure --with-mysql --with-pgsql --with-libstemmer --prefix=#{path}
      make && make install
    SHELL
  end
end
