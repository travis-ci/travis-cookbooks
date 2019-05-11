# frozen_string_literal: true

include_recipe 'travis_build_environment::pip'

execute 'pip install virtualenv==15.1.0'
