guard :rspec, spec_paths: "test/unit" do
  watch(%r{^test/unit/.+_spec\.rb$})
  watch(%r{^libraries/(.+)\.rb$}) { |m| "test/unit/libraries/#{m[1]}_spec.rb" }
  watch('test/unit/spec_helper.rb') { "spec" }
end

# guard :rspec do
#   watch(%r{^spec/.+_spec\.rb$})
#   watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
#   watch('spec/spec_helper.rb')  { "spec" }
# end

