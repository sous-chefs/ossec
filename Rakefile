require 'rspec/core/rake_task'
require 'rubocop/rake_task'

# Rspec and ChefSpec
desc 'Run ChefSpec unit tests'
RSpec::Core::RakeTask.new(:spec) do |t, _args|
  t.rspec_opts = 'spec/unit'
end

# Rubocop
RuboCop::RakeTask.new
