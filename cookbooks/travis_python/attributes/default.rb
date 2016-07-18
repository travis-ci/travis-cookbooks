include_attribute 'travis_build_environment'

default['travis_python']['pyenv']['revision'] = 'v20160629'

# Order matters for this list of Pythons. It will be used to construct the
# $PATH so items earlier in the list will take precedence over items later in
# the list. This order means that ``python`` will be 2.7.10, ``python2`` will be
# 2.7.10, and ``python3`` will be 3.5.0
default['travis_python']['pyenv']['pythons'] = %w(
  2.7.12
  3.5.2
  pypy-2.6.1
)

default['travis_python']['pyenv']['aliases'] = {
  '2.7.12' => %w(2.7),
  '3.5.2' => %w(3.5),
  'pypy-2.6.1' => %w(pypy)
}

default['travis_python']['pip']['packages'] = {
  'default' => %w(nose pytest mock wheel),
  '2.7' => %w(numpy),
  '3.5' => %w(numpy)
}

default['travis_python']['system']['pythons'] = %w(2.7 3.2)
if node['lsb']['codename'] == 'trusty'
  default['travis_python']['system']['pythons'] = %w(2.7 3.4)
end
