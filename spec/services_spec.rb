require 'spec_helper'

#
# List of service requirements
# Expected configuration should correspond to http://about.travis-ci.org/docs/user/database-setup/
#

[
  { :cookbook => 'mysql',         :recipe => 'server_on_ramfs',        :name => 'mysql',           :provider => :upstart,  :autostart => true  },
  { :cookbook => 'postgresql',    :recipe => 'default',                :name => 'postgresql',      :provider => :default,  :autostart => true  },

  { :cookbook => 'mongodb',       :recipe => 'default',                :name => 'mongodb',         :provider => :default,  :autostart => false },
  { :cookbook => 'couchdb',       :recipe => 'ppa',                    :name => 'couchdb',         :provider => :default,  :autostart => false },
  { :cookbook => 'rabbitmq',      :recipe => 'with_management_plugin', :name => 'rabbitmq-server', :provider => :default,  :autostart => false },
  { :cookbook => 'riak',          :recipe => 'default',                :name => 'riak',            :provider => :default,  :autostart => false },
  { :cookbook => 'memcached',     :recipe => 'default',                :name => 'memcached',       :provider => :default,  :autostart => false },
  { :cookbook => 'redis',         :recipe => 'default',                :name => 'redis-server',    :provider => :upstart,  :autostart => false },
  { :cookbook => 'cassandra',     :recipe => 'tarball',                :name => 'cassandra',       :provider => :default,  :autostart => false },
  { :cookbook => 'neo4j-server',  :recipe => 'tarball',                :name => 'neo4j',           :provider => :default,  :autostart => false },
  { :cookbook => 'elasticsearch', :recipe => 'default',                :name => 'elasticsearch',   :provider => :default,  :autostart => false },
  { :cookbook => 'kestrel',       :recipe => 'tarball',                :name => 'kestrel',         :provider => :default,  :autostart => false },

# Services present in travis-cookbooks, but not part of Travis CI (yet/anymore?)
#  { :cookbook => 'zeromq',        :recipe => 'ppa',                    :name => 'zeromq',          :provider => :default,  :autostart => false },
#  { :cookbook => 'hbase',         :recipe => 'cdh4',                   :name => 'hbase-master',    :provider => :default,  :autostart => false },
]
.each do |service|

  describe "Recipe #{service.cookbook}::#{service.recipe}" do
    let(:chef_run) {
      chef_run = create_chefspec_runner
      chef_run.converge "#{service.cookbook}::#{service.recipe}"
    }

    if service.provider == :upstart
      it "controls service #{service.name} with Upstart init mechanism" do
        expect(chef_run.service(service.name).provider).to eq(Chef::Provider::Service::Upstart)
      end
    else
      it "controls service #{service.name} with default (System-V) init mechanism" do
        expect(chef_run.service(service.name).provider).to be_nil
      end
    end

    if service.autostart
      it "configures service #{service.name} to start on boot" do
        expect(chef_run).to set_service_to_start_on_boot service.name

        #Low priority FIXME: Expectations disabled because ChefSpec seems only to fetch the first 'service' resource call
        #expect(chef_run.service(service.name).enabled).to be_true
        #expect(chef_run.service(service.name).running).to be_true
      end
    else
      it "configures service #{service.name} to not start on boot" do
        expect(chef_run).to set_service_to_not_start_on_boot service.name

        #Low priority FIXME: Expectations disabled because ChefSpec seems only to fetch the first 'service' resource call
        #expect(chef_run.service(service.name).enabled).to be_false
        #expect(chef_run.service(service.name).running).to be_false
      end
    end

  end

end
