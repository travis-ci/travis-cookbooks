require 'bundler/setup'
require 'chefspec'

module CiEnvironmentChefSpecHelpers
  def create_chefspec_runner
    chef_run = ChefSpec::ChefRunner.new(
      platform:        'ubuntu', 
      version:         '12.04',
      cookbook_path:   'ci_environment',
      evaluate_guards: false # disabled because of many unstubbed guards like "not_if command `which elasticsearch`"
    ) do |node|
      node.set['travis_build_environment'] = {
        'user'  => 'travis',
        'group' => 'travis'
      }
    end
  end
end

RSpec.configure do |config|
  config.include(CiEnvironmentChefSpecHelpers)
end
