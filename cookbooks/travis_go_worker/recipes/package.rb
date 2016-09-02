packagecloud_repo 'travisci/worker' do
  type 'deb'
end

package 'travis-worker'

include_recipe 'travis_go_worker::config'
