source "https://rubygems.org"

gem "faraday"
gem "faraday_middleware"
gem "inspec-bin", "~> 4.56"
gem "rake"

group :development do
  gem "pry"
  gem "pry-byebug"
end

group :development, :test do
  gem "chefstyle", "~> 2.2.2"
  # Pinning at version ~> 2.0 to support ruby 2.7
  gem "minitest", "~> 5.26", "<= 5.26.1"
  gem "rubocop", "~> 1.25.1", require: false
  gem "simplecov", "~> 0.21"
  gem "simplecov_json_formatter"
end
