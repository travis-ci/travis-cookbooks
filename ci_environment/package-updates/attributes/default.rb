include_attribute 'travis_build_environment'

default['travis_build_environment']['packages'] = %w(
  bash
  ca-certificates
)
