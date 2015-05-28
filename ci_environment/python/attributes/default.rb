default['python']['pyenv']['revision'] = 'v20150524'

# Order matters for this list of Pythons. It will be used to construct the
# $PATH so items earlier in the list will take precedence over items later in
# the list. This order means that ``python`` will be 2.7.10, ``python2`` will be
# 2.7.10, and ``python3`` will be 3.4.3
default['python']['pyenv']['pythons'] = %w(
  2.7.10
  2.6.9
  3.4.3
  3.3.5
  3.2.5
  pypy-2.5.1
  pypy3-2.4.0
)

default['python']['pyenv']['aliases'] = {
  '2.6.9' => %w(2.6),
  '2.7.10' => %w(2.7),
  '3.2.5' => %w(3.2),
  '3.3.5' => %w(3.3),
  '3.4.3' => %w(3.4),
  'pypy-2.5.1' => %w(pypy),
  'pypy3-2.4.0' => %w(pypy3),
}

default['python']['pip']['packages'] = {
  'default' => %w(nose pytest mock wheel),
  '2.6' => %w(numpy),
  '2.7' => %w(numpy),
  '3.2' => %w(numpy),
  '3.3' => %w(numpy),
  '3.4' => %w(numpy),
}

default['python']['system']['pythons'] = %w(2.7 3.2)
if node['lsb']['codename'] == 'trusty'
  default['python']['system']['pythons'] = %w(2.7 3.4)
end
