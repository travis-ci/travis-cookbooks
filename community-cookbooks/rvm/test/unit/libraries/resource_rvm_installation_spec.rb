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

describe Chef::Resource::RvmInstallation do

  let(:node) do
    node = Chef::Node.new
    node.set["rvm"]["installer_url"] = "http://example.com/rvm.me"
    node.set["rvm"]["installer_flags"] = "--buy-me beer"
    node.set["rvm"]["install_pkgs"] = ["cake", "pie"]
    node.set["rvm"]["gem_options"] = "--gem-all-the-things"
    node.set["rvm"]["rvmrc_env"] = { "RVM_EVERYTHING" => "maybe" }
    node
  end

  let(:resource_name) { "franky" }

  subject(:resource) do
    Chef::Resource::RvmInstallation.new(resource_name, run_context)
  end

  it "sets resource_name" do
    expect(resource.resource_name).to eq(:rvm_installation)
  end

  it "sets the provider class" do
    expect(resource.provider).to be(Chef::Provider::RvmInstallation)
  end

  it "sets the resource name" do
    expect(resource.name).to eq("franky")
  end

  context "attribute" do

    it "user can be set" do
      resource.user("root")
      expect(resource.user).to eq("root")
    end

    it "installer_url defaults to node.rvm.installer_url" do
      expect(resource.installer_url).to eq("http://example.com/rvm.me")
    end

    it "installer_url can be set" do
      resource.installer_url("https://www.google.ca/#q=rvm")
      expect(resource.installer_url).to eq("https://www.google.ca/#q=rvm")
    end

    it "installer_flags defaults to node.rvm.installer_flags" do
      expect(resource.installer_flags).to eq("--buy-me beer")
    end

    it "installer_flags can be set" do
      resource.installer_flags("--send pizza")
      expect(resource.installer_flags).to eq("--send pizza")
    end

    it "rvmrc_template_source defaults rvmrc.erb" do
      expect(resource.rvmrc_template_source).to eq("rvmrc.erb")
    end

    it "rvmrc_template_source can be set" do
      resource.rvmrc_template_source("that_other_one.erb")
      expect(resource.rvmrc_template_source).to eq("that_other_one.erb")
    end

    it "rvmrc_template_cookbook defaults to rvm" do
      expect(resource.rvmrc_template_cookbook).to eq("rvm")
    end

    it "rvmrc_template_cookbook can be set" do
      resource.rvmrc_template_cookbook("my_rvm_wrapper")
      expect(resource.rvmrc_template_cookbook).to eq("my_rvm_wrapper")
    end

    it "rvmrc_gem_options defaults to node.rvm.gem_options" do
      expect(resource.rvmrc_gem_options).to eq("--gem-all-the-things")
    end

    it "rvmrc_gem_options can be set" do
      resource.rvmrc_gem_options("--nope")
      expect(resource.rvmrc_gem_options).to eq("--nope")
    end

    it "rvmrc_env defaults to node.rvm.rvmrc_env" do
      expect(resource.rvmrc_env).to eq({"RVM_EVERYTHING" => "maybe"})
    end

    it "rvmrc_env can be set to merge with defaults" do
      resource.rvmrc_env({"FOO" => "is_bar", "this" => "too"})
      expect(resource.rvmrc_env).to eq({
        "RVM_EVERYTHING" => "maybe",
        "FOO" => "is_bar",
        "this" => "too"
      })
    end

    it "install_pkgs defaults to node.rvm.install_pkgs" do
      expect(resource.install_pkgs).to eq(["cake", "pie"])
    end

    it "installed can be set" do
      resource.installed(true)
      expect(resource.installed).to be_truthy
    end

    it "version can be set" do
      resource.version("x.y.z")
      expect(resource.version).to eq("x.y.z")
    end
  end

  it "action defaults to :install" do
    expect(resource.action).to eq(:install)
    expect(resource.allowed_actions).to include(:install)
  end
end
