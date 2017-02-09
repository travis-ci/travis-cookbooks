apt_repository 'neo4j' do
  uri 'https://debian.neo4j.org/repo'
  components %w(stable/)
  distribution ''
  key 'https://debian.neo4j.org/neotechnology.gpg.key'
end

package 'neo4j' do
  action %i(install upgrade)
end

service 'neo4j' do
  action %i(disable stop)
end
