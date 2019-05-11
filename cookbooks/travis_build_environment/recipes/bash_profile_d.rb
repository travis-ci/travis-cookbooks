# frozen_string_literal: true

directory ::File.join(
  node['travis_build_environment']['home'], '.bash_profile.d'
) do
  owner node['travis_build_environment']['user']
  group node['travis_build_environment']['group']
  mode 0o755
end
