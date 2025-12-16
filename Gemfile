source "https://rubygems.org"

gem "faraday"
gem "faraday_middleware"
gem "inspec-bin"
gem "rake"
# Pinning at version ~> 2.0 to support ruby versions < 3.2
gem "connection_pool", "~> 2.0"

group :development do
  gem "pry"
  gem "pry-byebug"
end

group :development, :test do
  gem "chefstyle", "~> 2.2.2"
  gem "minitest"
  gem "rubocop", "~> 1.25.1", require: false
  gem "simplecov", "~> 0.21"
  gem "simplecov_json_formatter"
end
