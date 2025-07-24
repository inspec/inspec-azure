source "https://rubygems.org"

if RUBY_VERSION.start_with?("2.7")
  gem "activesupport", "< 7"
  gem "zeitwerk", "< 2.7"
  gem "public_suffix", "< 5"
  gem "bigdecimal", "< 3.0"
  gem "json", "< 2.6"
  gem "concurrent-ruby", "< 1.2"
  gem "dry-core", "< 1.0"
  gem "dry-logic", "< 1.0"
else
  gem "activesupport"
end

gem "faraday"
gem "faraday_middleware"
gem "inspec-bin"
gem "rake"

group :development do
  gem "byebug", "< 12"
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
