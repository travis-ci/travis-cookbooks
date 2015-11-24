class TestMaven < MiniTest::Chef::TestCase

  def path
    "/usr/local/foobar/lib/"
  end

  def test_mysql_jar_unpacked
    assert File.exists? "#{path}/mysql-connector-java-5.1.19.jar"
  end

  def test_mysql_jar_perms
    file_mode = File.stat("#{path}/mysql-connector-java-5.1.19.jar").mode
    octal_mode = sprintf("%o", file_mode)[-4..-1]
    assert octal_mode == "0755"
  end

  def test_mysql_jar_owner
    require 'etc'
    assert File.stat("#{path}/mysql-connector-java-5.1.19.jar").uid == Etc.getpwnam("foobarbaz").uid
    assert File.stat("#{path}/mysql-connector-java-5.1.19.jar").gid == Etc.getpwnam("foobarbaz").gid
  end

  def test_javax_persistence_from_alt_repo
    assert File.exists? "#{path}/javax.persistence-2.0.0.jar"
  end

  def test_with_multiple_repos
    assert File.exists? "#{path}/postgresql-9.0-801.jdbc4.jar"
  end

  def test_alt_packaging
    assert File.exists? "#{path}/mm-mysql-2.0.13.pom"
  end

  def test_CamelCaseAliases
    assert File.exists? "#{path}/mm-mysql-2.0.13.pom"
  end

   def test_PutAction
    assert File.exists? "#{path}/solr-foo.war"
  end

  def test_mavenrc
     assert File.exists? "/etc/mavenrc"
  end

  def test_notifies
    assert File.exists? "/usr/local/notifyOne"
  end

  def test_is_idempotent
    assert !(File.exists? "/usr/local/notifyTwo")
  end
end
