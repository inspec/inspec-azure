source "https://rubygems.org"

# Faraday 2.x compatibility:
# - Built-in JSON and retry middleware, no separate faraday_middleware needed
# - JSON response parsing is included by default
# - Retry functionality requires faraday-retry gem in Faraday 2.x
gem "faraday"
gem "faraday-retry"
gem "inspec-bin", ">= 5.22.36", "< 6.0"
gem "rake"

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
