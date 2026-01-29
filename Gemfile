source "https://rubygems.org"

ruby "3.1.0"
gem "rails", "~> 7.2.3"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]
gem "bootsnap", require: false
gem "devise", "~> 4.9"
gem "devise_token_auth", "~> 1.2.6"
gem "pundit"
gem "active_model_serializers", "~> 0.10.0"
gem "rack-cors"
gem "kaminari"
gem "dotenv-rails"

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "bullet"
end

group :test do
  gem "shoulda-matchers"
  gem "faker"
end