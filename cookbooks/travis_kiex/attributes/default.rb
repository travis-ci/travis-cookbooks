include_attribute 'travis_build_environment'

default['travis_kiex']['default_elixir_version'] = '1.0.4'
default['travis_kiex']['elixir_versions'] = %W(
  1.0.3
  #{default['travis_kiex']['default_elixir_version']}
)
default['travis_kiex']['required_otp_release_for'] = {
  '1.0.3' => '17.4',
  '1.0.4' => '17.5'
}
