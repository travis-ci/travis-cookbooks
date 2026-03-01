# frozen_string_literal: true

Array(node['travis_java']['alternate_versions']).each do |java_version|
  include_recipe "travis_java::#{java_version}"
end
