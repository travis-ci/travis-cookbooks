# Poise-Python Changelog

## v1.1.1

* Fix passing options to the `python_package` resource.

## v1.1.0

* Add a `:dummy` provider for `python_runtime` for unit testing or complex overrides.
* Support installing development headers for SCL packages.
* Refactor Portable PyPy provider to use new helpers from `poise-languages`. This
  means `portable_pypy` and `portable_pypy3` are now separate providers but the
  auto-selection logic should still work as before.

## v1.0.0

* Initial release!

