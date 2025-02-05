# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "httparty", "~> 0.20"
gem "rake", "~> 13.0"
gem "rspec", "~> 3.0"
gem "rubocop", "~> 1.21"

group :development, :test do
  gem "rubocop-rake"
  gem "rubocop-rspec"
end

group :test do
  gem "faker", "~> 3.2"
  gem "pry", "~> 0.14.2"
  gem "vcr", "~> 6.2"
  gem "webmock", "~> 3.18"
end
