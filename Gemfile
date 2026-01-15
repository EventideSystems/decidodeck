# frozen_string_literal: true

source "https://rubygems.org"

gem "hanami", "~> 2.3.0"
gem "hanami-assets", "~> 2.3.0"
gem "hanami-controller", "~> 2.3.0"
gem "hanami-db", "~> 2.3.0"
gem "hanami-router", "~> 2.3.0"
gem "hanami-validations", "~> 2.3.0"
gem "hanami-view", "~> 2.3.0"

gem "dry-types", "~> 1.7"
gem "dry-operation", ">= 1.0.1"
gem "puma"
gem "rake"
gem "pg"

group :development do
  gem "hanami-webconsole", "~> 2.3.0"
end

group :development, :test do
  gem "dotenv"
end

group :cli, :development do
  gem "hanami-reloader", "~> 2.3.0"
end

group :cli, :development, :test do
  gem "hanami-rspec", "~> 2.3.0"
end

group :test do
  # Database
  gem "database_cleaner-sequel"

  # Web integration
  gem "capybara"
  gem "rack-test"
end
