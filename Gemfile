# frozen_string_literal: true

source 'https://rubygems.org'

gem 'faraday'
gem 'faraday_middleware'
gem 'inspec-bin'
gem 'rake'

if Gem.ruby_version < Gem::Version.new('2.7.0')
  gem 'activesupport', '< 7.0.0'
end

group :development do
  gem 'pry'
  gem 'pry-byebug'
end

group :development, :test do
  gem 'minitest'
  gem 'rubocop',  '~> 1.23.0'
end
