source "https://rubygems.org"

ruby "2.6.5"

gem "dotenv-rails", groups: [:development, :test]
gem "bootsnap", ">= 1.3", require: false
gem "rails", "~> 5.2.4"
gem "rails-i18n", "~> 5.1"
gem "pg", ">= 0.18", "< 2.0"
gem "bcrypt", "~> 3.1.13"
gem "uglifier", ">= 1.3.0"
gem "sass-rails", "~> 6.0"
gem "mini_magick", "~> 4.9"
gem "warden", "~> 1.2"
gem "addressable", "~> 2.7"
gem "shrine", "~> 2.19"
gem "aws-sdk-s3", "~> 1.60"
gem "image_processing", "~> 1.10"
gem "image_optim", "~> 0.26"
gem "image_optim_pack"
gem "redcarpet", "~> 3.5"
gem "font-awesome-rails", "~> 4.7"
gem "recaptcha", "~> 5.2"
gem "whenever", "1.0.0", require: false
gem "pundit", "~> 2"
gem "draper", "~> 3"
gem "simple_form", "~> 5"

group :development, :test do
  gem "standard"
  gem "rspec-rails"
  gem "puma"
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "web-console"
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
end

group :test do
  gem "factory_bot_rails"
  gem "shoulda-matchers"
  gem "rails-controller-testing"
  gem "simplecov", require: false
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
