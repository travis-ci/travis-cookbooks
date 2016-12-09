# Poise-Profiler Cookbook

[![Build Status](https://img.shields.io/travis/poise/poise-profiler.svg)](https://travis-ci.org/poise/poise-profiler)
[![Gem Version](https://img.shields.io/gem/v/poise-profiler.svg)](https://rubygems.org/gems/poise-profiler)
[![Cookbook Version](https://img.shields.io/cookbook/v/poise-profiler.svg)](https://supermarket.chef.io/cookbooks/poise-profiler)
[![Coverage](https://img.shields.io/codecov/c/github/poise/poise-profiler.svg)](https://codecov.io/github/poise/poise-profiler)
[![Gemnasium](https://img.shields.io/gemnasium/poise/poise-profiler.svg)](https://gemnasium.com/poise/poise-profiler)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

A [Chef](https://www.chef.io/) cookbook to display profiling information at the
end of the run.

Based on [chef-handler-profiler](https://github.com/joemiller/chef-handler-profiler)
by Joe Miller.

```
Poise Profiler:
Time          Resource
------------  -------------
    1.018142  execute[sleep 1]
    1.001729  ruby_block[test]
    0.006395  file[/test]

Time          Class
------------  -------------
    1.018142  Chef::Resource::Execute
    1.001729  Chef::Resource::RubyBlock
    0.006395  Chef::Resource::File

Profiler JSON: {"resources":{"ruby_block[test]":1.001729177,"file[/test]":0.006395018,"execute[sleep 1]":1.018141868},"classes":{"Chef::Resource::RubyBlock":1.001729177,"Chef::Resource::File":0.006395018,"Chef::Resource::Execute":1.018141868},"test_resources":{}}
```

## Quick Start

Add `recipe[poise-profiler]` to your run list or add `poise-profiler` as a
dependency in your `metadata.rb`.

## JSON Output

As shown above, JSON output is available for use with graphing or other trend
analysis. To enable this either set the environment variable `$CI` or the node
attribute `node['CI']`.

## Sponsors

Development sponsored by [Bloomberg](http://www.bloomberg.com/company/technology/).

The Poise test server infrastructure is sponsored by [Rackspace](https://rackspace.com/).

## License

Copyright 2016, Noah Kantrowitz

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
