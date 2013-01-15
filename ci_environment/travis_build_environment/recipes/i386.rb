# Install support of 32-bit binaries on 64-bit operating system

if node['travis_build_environment']['arch'] == 'amd64'
  package 'ia32-libs'
end

