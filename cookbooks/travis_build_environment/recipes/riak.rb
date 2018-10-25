# frozen_string_literal: true

packagecloud_repo 'basho/riak' do
  type 'deb'
end

package 'riak'

service 'riak' do
  action %i[disable stop]
end
