#
# Cookbook Name:: rvm
# Recipe:: multi
# Copyright 2011-2012, Travis CI development team
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

include_recipe "rvm"

# for JRuby and JRuby 1.6.x in 1.9 mode by default.
# For rvm::multi we assume it's OK to enforce JDK and assume JRuby will be
# provided. MK.
include_recipe "java"
include_recipe "ant"

log "Using Ruby #{RUBY_VERSION}..."

default_ruby = node[:rvm][:default]
gems         = node[:rvm].fetch(:gems, []) | ['bundler', 'rake']
aliases      = node[:rvm][:aliases] || []

log "Default Ruby will be #{default_ruby}"

home = node.travis_build_environment.home
rvm  = "source #{home}/.rvm/scripts/rvm && rvm"
env  = { 'HOME' => home, 'rvm_user_install_flag' => '1' }
user = node.travis_build_environment.user

setup = lambda do |bash|
  bash.user user
  bash.environment env
end

# make sure default Ruby is installed first
bash "installing #{default_ruby}" do
  setup.call(self)
  # we install rake here because it needs to be available by the time Rubiniuses are compiled. MK.
  code   "rm -rf $HOME/.rvm/gemsets/global.gems && rm -rf $HOME/.rvm/gemsets/default.gems && #{rvm} install #{default_ruby} && #{rvm} use --default #{default_ruby} && #{rvm} @global do gem install rake"
  not_if "#{rvm} #{default_ruby} do echo 'Found'"
end

node.rvm.rubies.each do |rb|
  bash "installing #{rb[:name]} with RVM arguments #{rb[:arguments]}" do
    setup.call(self)
    code   "#{rvm} use #{rb.fetch(:using, default_ruby)} && #{rvm} install #{rb[:name]} #{rb[:arguments]}"
    # with all the Rubies we provide, checking for various directories under .rvm/rubies/* is pretty much impossible without
    # depending on the exact versions provided. So we use this neat technique suggested by
    # mpapis. MK.
    not_if "#{rvm} #{rb[:check_for] || rb[:name]} do echo 'Found'"
  end
end


# now we can install gems by iterating over rubies in any order. MK.
node.rvm.rubies.each do |rb|
  # handle cases when Rubinius in 1.9 mode will have the same :name
  # as Rubinius in 1.8 but will be available via rvm under a different name. MK.
  name = rb[:check_for] || rb[:name]

  # bundler 1.1+ requires 1.8.7. We still keep 1.8.6 for Sinatra but
  # DO NOT depend on it being available. MK.
  if name == "1.8.6"
    bash "installing gems for #{name}" do
      setup.call(self)
      code   "#{rvm} use #{name}; gem install rake --no-ri --no-rdoc; gem install bundler --version '~> 1.0.21' --no-ri --no-rdoc"
    end
  else
    gems.each do |gem|
      bash "installing gem #{gem} for #{name}" do
        setup.call(self)
        code   "#{rvm} use #{name}; gem install #{gem} --no-ri --no-rdoc"
      end
    end
  end
end

aliases.each do |new_name, existing_name|
  bash "alias #{existing_name} => #{new_name}" do
    setup.call(self)
    code "#{rvm} alias create #{new_name} #{existing_name}"
    ignore_failure true # alias creation is not idempotent. MK.
  end
end

bash "clean up RVM sources, log files, etc" do
  setup.call(self)
  code "#{rvm} cleanup all"
end
