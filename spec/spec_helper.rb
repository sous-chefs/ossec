require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true               # Use color in STDOUT
  config.formatter = :documentation # Use the specified formatter
  config.platform = 'ubuntu'
  config.version = '16.04'
end
