# timetrap cookbook

This cookbook contains a simple shell script that time-traps other executables. It is installed
to /usr/local/bin/timetrap.sh and is executable by everyone.

Useful when you want to make sure that operations like `bundle install` or CI test runs do not
hang on for hours.


## Copyright

Original time-trapping shell script is courtesy of Dmitry V Golovashkin.


## License

MIT, same as other [Travis CI](https://github.com/travis-ci) packages.
