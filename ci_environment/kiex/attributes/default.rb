default[:kiex][:elixir_versions] = ['1.0.2']
default[:kiex][:default_elixir_version] = '1.0.2'
# we assume that required OTP releases are installed by 'kerl' cookbook
default[:kiex][:required_otp_release_for] = {
  '1.0.2' => '17.4'
}
