#!/usr/bin/env ruby

if ARGV.empty?
  puts "Requires at least one argument"
  exit 1
end

child_pid = nil

%w{INT TERM}.each do |signal|
  trap signal do
    puts "Terminating child"
    Process.kill(:TERM, child_pid)
    exit
  end
end

child_pid = Kernel.fork do
  Process.exec(*ARGV)
end

Process.wait(child_pid)
