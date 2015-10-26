require "chef/platform"
require "chef/run_context"
require "chef/resource"
require "chef/event_dispatch/base"
require "chef/event_dispatch/dispatcher"

$:.unshift(File.join(File.dirname(__FILE__), "..", "..", "libraries"))

module Helpers

  def events
    @events ||= Chef::EventDispatch::Dispatcher.new
  end

  def run_context
    @run_context ||= Chef::RunContext.new(node, {}, events)
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.formatter = :documentation
end
