# Changelog

## v2.4.0

* Added return value to `Container#register_subresource` to track if the resource
  was already added.
* Improve inspect output for subresources and containers.
* Ensure notifications work with subresources.
* Inversion providers process name equivalences.

## v2.3.2

* Improve handling of deeply nested subresources.

## v2.3.1

* Ensure a container with a parent link to its own type doesn't use self as the
  default parent.
* Improve handling of `load_current_resource` in providers that call it via
  `super`.

## v2.3.0

* New helper: `ResourceSubclass`, a helper for subclassing a resource while
  still using the providers as the base class.
* New feature: Non-default containers. Use `container_default: false` to mark
  a container class as ineligible for default lookup.
* New feature: parent attribute defaults. You can set a `parent_default` to
  provide a default value for the parent of a resource. This supports the
  `lazy { }` helper as with normal default values.
* New feature: use `forced_keys: [:name]` on an option collector property to
  force keys that would otherwise be clobbered by resource methods.
* Can enable verbose logging mode via a node attribute in addition to an
  environment variable.

## v2.2.3

* Add `ancestor_send` utility method for use in other helpers.
* Improve subresource support for use in mixins.

## v2.2.2

* Fix 2.2.1 for older versions of Chef.

## v2.2.1

* Fixed delayed notifications inside `notifying_block`.
* Default actions as expected within LWRPs.

## v2.2.0

* Compatibility with Chef 12.4.1 and Chefspec 4.3.0.
* New helper `ResourceCloning`: Disables resource cloning between Poise-based
  resources. This is enabled by default.
* Subresource parent references can be set to nil.

## v2.1.0

* Compatibility with Chef 12.4.
* Add `#property` as an alias for `#attribute` in resources. This provides
  forward compatibility with future versions of Chef.
* Freeze default resource attribute values. **This may break your code**,
  however this is not a major release because any code broken by this change
  was itself already a bug.

## v2.0.1

* Make the ChefspecHelpers helper a no-op if chefspec is not already loaded.
* Fix for finding the correct cookbook for a file when using vendored gems.
* New flag for the OptionCollector helper, `parser`:

```ruby
class Resource < Chef::Resource
  include Poise
  attribute(:options, option_collector: true, parser: proc {|val| parse(val) })

  def parse(val)
    {name: val}
  end
end
```

* Fix for a possible infinite loop when using `ResourceProviderMixin` in a nested
  module structure.

## v2.0.0

Major overhaul! Poise is now a Halite gem/cookbook. New helpers:

* ChefspecMatchers – Automatically create Chefspec matchers for Poise resources.
* DefinedIn – Track which file (and cookbook) a resource or provider is defined in.
* Fused – Experimental support for defining provider actions in the resource class.
* Inversion – Support for end-user dependency inversion with providers.

All helpers are compatible with Chef >= 12.0. Chef 11 is now deprecated, if you
need to support Chef 11 please continue to use Poise 1.

## v1.0.12

* Correctly propagate errors from inside notifying_block.

## v1.0.10

* Fixes an issue with the LWRPPolyfill helper and false values.


## v1.0.8

* Delayed notifications from nested converges will still only run at the end of
  the main converge.

## v1.0.6

* The include_recipe helper now works correctly when used at compile time.

## v1.0.4

* Redeclaring a template attribute with the same name as a parent class will
  inherit its options.

## v1.0.2

* New template attribute pattern.

```ruby
attribute(:config, template: true)

...

resource 'name' do
  config_source 'template.erb'
end

...

new_resource.config_content
```

## v1.0.0

* Initial release!
