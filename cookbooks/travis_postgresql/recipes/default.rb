# frozen_string_literal: true

include_recipe 'travis_postgresql::all_packages'
include_recipe 'travis_postgresql::ci_server'

service 'postgresql' do
  if node['travis_postgresql']['enabled']
    action %i[enable restart]
  else
    action %i[disable restart]
  end
end
