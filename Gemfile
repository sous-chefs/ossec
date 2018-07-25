source 'https://rubygems.org'

ruby File.open(File.expand_path('.ruby-version', File.dirname(__FILE__))) { |f| f.read.chomp }

gem 'berkshelf'
gem 'chef', '~> 12'
gem 'cookbook_release', git: 'git@github.com:tablexi/chef-cookbook_release_tasks.git'

group :dev do
  gem 'chefspec'
  gem 'foodcritic'
  gem 'rubocop'
end

group :kitchen do
  gem 'chef-zero'
  gem 'kitchen-ec2'
  gem 'kitchen-inspec'
  gem 'kitchen-transport-rsync'
  gem 'kitchen-vagrant'
  gem 'test-kitchen'
end

group :guard do
  gem 'guard'
  gem 'guard-foodcritic'
  gem 'guard-kitchen'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'ruby_gntp'
end
