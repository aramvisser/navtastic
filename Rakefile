require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'
require './spec/demo/server'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--order rand"
end

RuboCop::RakeTask.new

YARD::Rake::YardocTask.new

desc "Run the demo server"
task :demo do
  DemoServer.new(9090).start
end

task default: %i[spec rubocop]
