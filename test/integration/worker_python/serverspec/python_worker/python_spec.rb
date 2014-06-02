require 'spec_helper'

describe 'python versions' do
  describe command('python --version') do
    its(:stdout) { should match(/Python 2\.\d+\.\d+/) }
  end

  describe command('python2 --version') do
    its(:stdout) { should match(/Python 2\.\d+\.\d+/) }
  end

  describe command('python3 --version') do
    its(:stdout) { should match(/Python 3\.\d+\.\d+/) }
  end
end

describe 'python tools' do
  let(:cmd) { 'source virtualenv/pypy/bin/activate && nosetests' }
  describe command_as_travis(cmd) do
    it { should return_exit_status 0 }
  end
end
