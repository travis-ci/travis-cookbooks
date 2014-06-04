require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "Version Control tools" do
  describe "git" do
    describe command('git --version') do
      its(:stdout) { should match(/git version.*/) }
    end
  end

  describe "mercurial" do
    describe command('hg --version') do
      its(:stdout) { should match(/Mercurial Distributed SCM \(version \d.\d\)/) }
    end
  end

  describe "subversion" do
    describe command('svn --version') do
      its(:stdout) { should match(/svn, version */) }
    end
  end
end