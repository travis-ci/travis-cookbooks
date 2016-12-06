# compat_resource cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/compat_resource.svg?branch=master)](https://travis-ci.org/chef-cookbooks/compat_resource)
[![Cookbook Version](https://img.shields.io/cookbook/v/compat_resource.svg)](https://supermarket.chef.io/cookbooks/compat_resource)


This cookbook brings the custom resource syntax from Chef 12.5 to earlier Chef 12.X releases.

## Converting cookbooks from the old resource model to the new

### Boilerplate

1. Depend on compat_resource
   - Descend resources from ChefCompat::Resource
   - Set resource_name in the class instead of the constructor
2. Convert Attributes to Properties
   - Rename attribute -> property
   - Move set_or_return -> property
   - Take kind_of/equal_to/regexes and make them types
   - Use true/false/nil instead of TrueClass/FalseClass/NilClass
   - Remove default: nil (it's the default)
3. Convert Top-Level Providers to Actions
   - Create any resources that don't already exist (for example in
     multi-provider cases) and descend from the base resource
   - Remove allowed_actions / @actions
   - @action -> default_action
   - Move `provides` and `action :x` to the resource
   - Remove use_inline_resources and def whyrun_safe?
   - Move other methods to `action_class.class_eval do`

Now you have everything in a resource, are using properties, and have gotten rid
of a bunch of boilerplate. Of course, this is just getting it *moved*. Now you
can start to really use the new features. And if you're making resources for
the first time, congrats--you probably didn't have to do very much of this :)

### Advanced Concepts

1. Resource Inheritance
2. Resources That Are Different On Each OS?
3. Coercion: Handling User Input
4. Lazy Defaults
5. Using Load Current Resource
6. Using Converge If Changed
7. Defaults Are For Creation
8. Shared types: using a type multiple places



Requirements
------------
#### Platforms
- All platforms supported by Chef

#### Chef
- Chef 12.0+

#### Cookbooks
- none


## Usage

To use this cookbook, put `depends 'compat_resource'` in the metadata.rb of your cookbook. Once this is done, you can use all the new custom resource features to define resources. It Just Works.

For example, if you create resources/myresource.rb, myresource can use `property`, `load_current_value` and `action` (no need to create a provider). If you want to create Resource classes directly, extend from `ChefCompat::Resource` instead of `Chef::Resource`. Properties, current value loading, converge_if_changed, and resource_name will all function the same across versions.

## Custom Resources?

Curious about how to use custom resources? Here are the 12.5 docs:

- Docs: https://docs.chef.io/custom_resources.html
- Slides: https://docs.chef.io/decks/custom_resources.html


##License & Authors

**Author:** John Keiser (<jkeiser@chef.io>)

**Copyright:** 2015, Chef Software, Inc.
```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
