# frozen_string_literal: true

module TravisPostgresqlMethods
  module_function

  def pg_versions(node)
    values = [node['travis_postgresql']['default_version']]
    Array(node['travis_postgresql']['alternate_versions']).each do |pg_version|
      values << pg_version
    end
    values
  end
end
