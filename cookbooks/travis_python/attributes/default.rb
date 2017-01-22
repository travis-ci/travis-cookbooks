include_attribute 'travis_build_environment'

default['travis_python']['pyenv']['revision'] = 'v1.0.6'

# Order matters for this list of Pythons. It will be used to construct the
# $PATH so items earlier in the list will take precedence over items later in
# the list. This order means that ``python`` will be 2.7.13, ``python2`` will be
# 2.7.13, and ``python3`` will be 3.6.0
default['travis_python']['pyenv']['pythons'] = %w(
  2.7.13
  3.6.0
  pypy2-5.6.0
)

default['travis_python']['pyenv']['aliases'] = {
  '2.7.13' => %w(2.7),
  '3.6.0' => %w(3.6),
  'pypy2-5.6.0' => %w(pypy)
}

default['travis_python']['pip']['packages'] = {
  'default' => %w(nose pytest mock wheel),
  '2.7' => %w(numpy),
  '3.6' => %w(numpy)
}

default['travis_python']['system']['pythons'] = %w(2.7 3.2)
if node['lsb']['codename'] == 'trusty'
  default['travis_python']['system']['pythons'] = %w(2.7 3.4)
end
