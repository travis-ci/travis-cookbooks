# frozen_string_literal: true

include_attribute 'travis_build_environment'

default['travis_perlbrew']['prerequisite_packages'] = %w[perl]
