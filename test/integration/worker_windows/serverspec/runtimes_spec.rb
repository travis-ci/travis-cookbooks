require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe "Version Control tools" do
  describe "Ruby" do
    describe command('ruby --version') do
      its(:stdout) { should match(/ruby \d+\.\d+\.\d+/) }
    end

    describe command('bundle --version') do
      its(:stdout) { should match(/Bundler version */) }
    end
  end

  describe "Java" do
    describe command('java -version') do
      its(:stdout) { should match(/Java\(TM\) SE Runtime Environment \(build/) }
    end
  end

  describe "Python" do
    describe command('svn --version') do
      its(:stdout) { should match(/svn, version */) }
    end
  end

  describe "Node.js" do
    describe command('node --version') do
      its(:stdout) { should match(/v\d+\.\d+\.\d+/) }
    end

    describe command('npm --version') do
      its(:stdout) { should match(/\d+\.\d+\.\d+*/) }
    end
  end

  describe "Go" do
    describe command('go version') do
      its(:stdout) { should match(/go version go\d+\.\d+\.\d/) }
    end
  end
end