[![Build Status](https://travis-ci.org/opsmatic/opsmatic-cookbook.svg?branch=master)](https://travis-ci.org/opsmatic/opsmatic-cookbook)

opsmatic Cookbook
======================
This cookbook contains various recipes to help you with integrating your infrastructure with Opsmatic. The recipes
contained in this cookbook are as follows:

#### opsmatic::handler

This recipe configures a report and exception handler that sends detail on successful and failed runs to Opsmatic

#### opsmatic::agent

This recipe configures the opsmatic collection agent

#### opsmatic::file-integrity-monitoring

This recipe configures file monitoring for the agent



Requirements
------------
#### opsmatic::handler

The Opsmatic report handler depends on the [chef_handler](https://github.com/opscode-cookbooks/chef_handler) cookbook

Attributes
----------

* `node[:opsmatic][:integration_token]` - You must configure this attribute with your integration token. You can find your
integration token on the [Integrations](https://opsmatic.com/app/integrations) page in your Opsmatic account.

#### opsmatic::handler

* `node[:opsmatic][:ssl_peer_verify]` - Enables/Disable OpenSSL peer verification. Defaults to false (no peer verificaiton) until we can work out a consistent and reliable way to make this work for everyone.
* `node[:opsmatic][:handler_version]` - Version of the chef-handler-opsmatic rubygem to use. We suggest you set this attribute somewhere globally in your environment, we'll notify you when upgrades are available
and you can bump the version number.

#### opsmatic::agent

* `node[:opsmatic][:agent_action]` - determines whether chef should attept to
`upgrade` the agent on every subsequent run
* `node[:opsmatic][:handler_version]` - pins the agent to a specific version.
Default behavior is to install the latest available version the first time
around and stay put after that.
* `node[:opsmatic][:host_alias]` - specifies the host's alias in `/etc/opsmatic-agent.conf`
* `node[:opsmatic][:groups]` - specifies the group that a host belongs to in `/etc/opsmatic-agent.conf`

More information regarding the latter two attributes can be located [here](https://opsmatic.com/app/docs/agent-configuration)

#### opsmatic::file-integrity-monitoring

* `node[:opsmatic][:file-monitor-list]` - takes an array of strings that contain file paths for [file integrity monitoring](https://opsmatic.com/app/docs/file-integrity-monitoring):
`"file-monitor-list": ['/etc/nginx/nginx.conf','/etc/ssh/sshd_config','/etc/rsyslog.conf','/etc/hosts','/etc/passwd']`


Usage
-----
#### opsmatic::handler && opsmatic::agent

To wire the handler into your infrastructure, add the `opsmatic::handler` recipe as the first item in the run list
of your node or role (You will need to use the agent as well).

```json
    {
        "name": "my_node",
        "run_list": [
           "recipe[opsmatic::handler]",
           "recipe[opsmatic::agent]"
        ]
    }
``` 

The attributes will look something like this:

```json
    "attributes": {
        "opsmatic": {
            "integration_token": "YOUR-INTEGRATION-TOKEN",
            "file-monitor-list": ["/etc/nginx/nginx.conf","/etc/ssh/sshd_config","/etc/rsyslog.conf","/etc/hosts","/etc/passwd"],
            "host_alias": "chefcookbookhostname",
            "groups": ["groupone", "anothergroup", "yetanothergroup"]
        }
    }
```

To install just the agent remove the opsmatic::handler recipe.

Contributing
------------
1. Fork it ( https://github.com/opsmatic/opsmatic-cookbook/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
