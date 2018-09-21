apt_repository 'git-ppa' do
  uri 'ppa:git-core/ppa'
  retries 2
  retry_delay 30
end

package %w[git git-core] do
  action %i[install upgrade]
end

packagecloud_repo 'github/git-lfs' do
  type 'deb'
  not_if { node['kernel']['machine'] == 'ppc64le' }
end

package 'git-lfs' do
  action %i[install upgrade]
  not_if { node['kernel']['machine'] == 'ppc64le' }
end
