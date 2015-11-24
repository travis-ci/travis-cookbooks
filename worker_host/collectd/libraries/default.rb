#
# Cookbook Name:: collectd
# Library:: default
#
# Copyright 2010, Atari, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def collectd_key(option)
  return option.to_s.split('_').map{|x| x.capitalize}.join() if option.instance_of?(Symbol)
  "#{option}"
end

def collectd_option(option)
  return option if option.instance_of?(Fixnum) || option == true || option == false
  "\"#{option}\""
end

def collectd_settings(options, level=0)
  indent = '  ' * level
  output = []
  options.each_pair do |key, value|
    if value.is_a? Array
      value.each do |subvalue|
        output << "#{indent}#{collectd_key(key)} #{collectd_option(subvalue)}"
      end
    elsif value.is_a? Hash
      value.each_pair do |name, suboptions|
        output << "#{indent}<#{key} \"#{name}\">\n#{collectd_settings(suboptions, level+1)}\n#{indent}</#{key}>"
      end
    else
      output << "#{indent}#{collectd_key(key)} #{collectd_option(value)}"
    end
  end
  output.join("\n")
end
