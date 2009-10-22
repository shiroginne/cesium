require 'shell'

spec_path = 'spec'

@dir = File.dirname(@path)

@shell ||= Shell.new
Shell.def_system_command :spec, spec_path unless @shell.respond_to? :spec
Shell.def_system_command :notify, "notify-send" unless @shell.respond_to? :notify

def notificate text
  system "notify-send -t 30000 \"Spec result\" \"#{text.gsub('`', '\'')}\n\n---\""
end

def run_specs *specs
  specs.flatten!
  process = @shell.transact do
    spec(*(specs << '-O' << 'spec/spec.opts'))
  end
  output = process.to_s
  output.split("\n").each do |line|
    puts line
  end
  notificate output
end

def run_all_tests
  run_specs Dir[File.join(@dir, 'spec/**/*_spec.rb')]
end

run_all_tests

watch('^spec/.*/[a-z_]*_spec\.rb') { |m| run_specs File.join(@dir, m[0])}
watch('^app/(.*/[a-z_]*)\.rb') { |m| run_specs File.join(@dir, "spec/#{m[1]}_spec.rb") if File.exists?(File.join(@dir, "spec/#{m[1]}_spec.rb")) }
watch('^app/(.*/[a-z_]*\.(html\.erb|haml|rjs|js\.erb))') { |m| rin_specs File.join(@dir, "spec/#{m[1]}_spec.rb") if File.exists?(File.join(@dir, "spec/#{m[1]}_spec.rb")) }
watch('^lib/(.*/[a-z_]*)\.rb') { |m| run_specs File.join(@dir, "spec/lib/#{m[1]}_spec.rb") if File.exists?(File.join(@dir, "spec/lib/#{m[1]}_spec.rb")) }

# Ctrl-\
Signal.trap('QUIT') do
  puts "\n--- Run all specs ---\n\n"
  run_all_tests
end

# Ctrl-C
Signal.trap('INT') { abort("\n--- Aborting ---\n\n") }
