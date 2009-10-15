@dir = File.dirname(@path)

def run_all_tests
  system "spec #{Dir[File.join(@dir, 'spec/**/*_spec.rb')].join(' ')} -O spec/spec.opts"
end

run_all_tests

watch('^spec/.*/[a-z_]*_spec\.rb') { |m| system "spec #{File.join(@dir, m[0])} -O spec/spec.opts" }
watch('^app/(.*/[a-z_]*)\.rb') { |m| system "spec #{File.join(@dir, "spec/#{m[1]}_spec.rb")} -O spec/spec.opts" if File.exists?("spec/#{m[1]}_spec.rb") }
watch('^app/(.*/[a-z_]*\.(html\.erb|haml|rjs|js\.erb))') { |m| system "spec #{File.join(@dir, "spec/#{m[1]}_spec.rb")} -O spec/spec.opts" if File.exists?("spec/#{m[1]}_spec.rb") }
watch('^lib/(.*/[a-z_]*)\.rb') { |m| system "spec #{File.join(@dir, "spec/lib/#{m[1]}_spec.rb")} -O spec/spec.opts" if File.exists?("spec/lib/#{m[1]}_spec.rb") }

# Ctrl-\
Signal.trap('QUIT') do
  puts "\n--- Run all specs ---\n\n"
  run_all_tests
end

# Ctrl-C
Signal.trap('INT') { abort("\n--- Aborting ---\n\n") }
