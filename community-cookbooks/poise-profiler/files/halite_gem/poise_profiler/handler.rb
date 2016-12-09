#
# Copyright 2016, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

begin
  require 'chef/chef_class'
rescue LoadError
  # ¯\_(ツ)_/¯ Chef < 12.3.
end
require 'chef/event_dispatch/base'
require 'chef/json_compat'


module PoiseProfiler
  class Handler < Chef::EventDispatch::Base
    include Singleton

    # Used in {#monkey_patch_old_chef}
    # @api private
    attr_writer :events, :monkey_patched

    def resource_completed(resource)
      key = resource.resource_name.to_s.end_with?('_test') ? :test_resources : :resources
      timers[key]["#{resource.resource_name}[#{resource.name}]"] += resource.elapsed_time
      timers[:classes][resource.class.name] += resource.elapsed_time
    end

    def run_completed(node)
      Chef::Log.debug('Processing poise-profiler data')
      puts('Poise Profiler:')
      puts_timer(:resources, 'Resource')
      puts_timer(:test_resources, 'Test Resource') unless timers[:test_resources].empty?
      puts_timer(:classes, 'Class')
      puts("Profiler JSON: #{Chef::JSONCompat.to_json(timers)}") if ENV['CI'] || node['CI']
      puts('')
    end

    def run_failed(_run_error)
      run_completed(nil)
    end

    def reset!
      timers.clear
      @events = nil
    end

    # Inject this instance for Chef < 12.3. Don't call this on newer Chef.
    def monkey_patch_old_chef!
      return if @monkey_patched
      require 'chef/event_dispatch/dispatcher'
      instance = self
      orig_method = Chef::EventDispatch::Dispatcher.instance_method(:library_file_loaded)
      Chef::EventDispatch::Dispatcher.send(:define_method, :library_file_loaded) do |filename|
        instance.events = self
        instance.monkey_patched = false
        @subscribers << instance
        Chef::EventDispatch::Dispatcher.send(:define_method, :library_file_loaded, orig_method)
        orig_method.bind(self).call(filename)
      end
      @monkey_patched = true
    end

    private

    def timers
      @timers ||= Hash.new {|hash, key| hash[key] = Hash.new(0) }
    end

    def puts_timer(key, label)
      puts "Time          #{label}"
      puts "------------  -------------"
      timers[key].sort_by{ |k,v| -v }.each do |val, run_time|
        puts "%12f  %s" % [run_time, val]
      end
      puts ""
    end

    def puts(line)
      events.stream_output(:profiler, line+"\n")
    end

    def events
      @events ||= Chef.run_context.events
    end

  end
end
