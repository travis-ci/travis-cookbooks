#
# Cookbook Name:: rvm
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2013, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative "../spec_helper"
require "resource_rvm_installation"
require "provider_rvm_installation"

describe Chef::Provider::RvmInstallation do

  let(:node) do
    n = Chef::Node.new
    n.set["rvm"]["installer_url"] = "http://rvm.me"
    n.set["rvm"]["installer_flags"] = "stable"
    n.set["rvm"]["install_pkgs"] = ["cake", "pie"]
    n.set["rvm"]["rvmrc_env"] = {"RVM_ENABLE" => "alittle"}
    n
  end

  let(:new_resource) do
    r = Chef::Resource::RvmInstallation.new("franky", run_context)
    r.rvmrc_template_cookbook("nadda")
    r
  end

  let(:current_resource) do
    Chef::Resource::RvmInstallation.new("franky", run_context)
  end

  let(:nutered_resources) do
    [Chef::Resource::Package, Chef::Resource::RemoteFile,
      Chef::Resource::Template]
  end

  subject(:provider) do
    Chef::Provider::RvmInstallation.new(new_resource, run_context)
  end

  before do
    nutered_resources.each do |klass|
      klass.any_instance.stub(:run_action).and_return(true)
    end
    provider.stub(:load_current_resource).and_return(current_resource)
    provider.stub(:version).and_return("6.7.8")
    provider.new_resource = new_resource
    provider.current_resource = current_resource

    Etc.stub(:getpwnam).with("franky").and_return(
      double("user", :dir => "/fake/home/franky", :uid => 101, :gid => 601)
    )
  end

  describe "#load_current_resource" do

    before do
      provider.unstub(:load_current_resource)
      provider.unstub(:version)

      provider.stub(:shell_out).
        with(/type rvm/, hash_including(:user => "franky")).
        and_return(installed_cmd)
      provider.stub(:shell_out).
        with(/rvm version/, hash_including(:user => "franky")).
        and_return(version_cmd)
    end

    context "rvm is installed" do

      let(:installed_cmd) do
        double("output",
          :stdout => ["rvm is a function", "rvm ()", "{", "eh", "}"].join("\n"),
          :exitstatus => 0
        )
      end

      let(:version_cmd) do
        double("output",
          :stdout => "\nrvm 400.23.9 () yadda yadda\n\n",
          :exitstatus => 0
        )
      end

      it "sets installed state to true" do
        provider.load_current_resource

        expect(provider.current_resource.installed).to be_truthy
      end

      it "sets version state" do
        provider.load_current_resource

        expect(provider.current_resource.version).to eq("400.23.9")
      end

      context "with a mangled version string" do

        let(:version_cmd) do
          double("output",
            :stdout => "\nuh oh rvm cake () yadda yadda\n\n",
            :exitstatus => 0
          )
        end

        it "raises an exception" do
          expect{ provider.load_current_resource }.to raise_error
        end
      end

      context "with a non-zero version command" do

        let(:version_cmd) do
          double("output",
            :stdout => "\nrvm 1.2.3 () yadda yadda\n\n",
            :exitstatus => 6
          )
        end

        it "raises an exception" do
          expect{ provider.load_current_resource }.to raise_error
        end
      end
    end

    context "rvm is not installed" do

      let(:installed_cmd) do
        double("output", :stdout => "who cares, it failed\n", :exitstatus => 1)
      end

      let(:version_cmd) do
        double("output", :stdout => "not what you expected?", :exitstatus => 1)
      end

      it "sets installed state to false" do
        provider.load_current_resource

        expect(provider.current_resource.installed).to be false
      end
    end
  end

  describe "actions" do

    describe "install" do

      before do
        provider.current_resource.installed(true)
        provider.stub(:rvm_shell_out!).with(/^bash/)
      end

      let(:cache_path) { Chef::Config[:file_cache_path] }

      it "creates a collection of packages to install" do
        expect(provider.install_packages.map { |pkg| pkg.name }).to eq(%w(cake pie))
      end

      it "calls the package resources" do
        expect(provider).to receive(:install_packages)

        provider.install_rvm
      end

      it "creates a template to manage rvmrc" do
        template = provider.send(:write_rvmrc)

        expect(template.class).to be(Chef::Resource::Template)
        expect(template.name).to eq("/fake/home/franky/.rvmrc")
        expect(template.owner).to eq("franky")
        expect(template.group).to eq(601)
        expect(template.mode).to eq("0644")
        expect(template.source).to eq("rvmrc.erb")
        expect(template.cookbook).to eq("nadda")
        expect(template.variables).to eq(
          :user => "franky",
          :rvm_path => "/fake/home/franky/.rvm",
          :rvmrc_env => {"RVM_ENABLE" => "alittle"}
        )
      end

      it "creates a remote_file to download the installer script" do
        remote_script = provider.send(:download_installer)

        expect(remote_script.class).to be(Chef::Resource::RemoteFile)
        expect(remote_script.name).to eq("#{cache_path}/rvm-installer-franky")
        expect(Array(remote_script.source)).to include("http://rvm.me")
      end

      it "calls the remote_file" do
        expect(provider).to receive(:download_installer)

        provider.install_rvm
      end

      it "runs the installer" do
        provider.stub(:rvm_shell_out!)
        expect(provider).to receive(:rvm_shell_out!).with(
          "bash #{cache_path}/rvm-installer-franky stable"
        )

        provider.install_rvm
      end
    end
  end
end
