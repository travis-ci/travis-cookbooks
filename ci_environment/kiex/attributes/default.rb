default[:kiex][:default_elixir_version] = '1.0.3'
default[:kiex][:elixir_versions] = [ default[:kiex][:default_elixir_version] ]
# we assume that required OTP releases are installed by 'kerl' cookbook
default[:kiex][:required_otp_release_for] = {
  '1.0.3' => '17.4'
}
