source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'awesome_print'
gem 'bulk_insert'
gem 'devise_invitable'
gem 'devise'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'faker'
gem 'friendly_id', '~> 5.1.0'
gem 'graphiql-rails', group: :development
gem 'graphql'
gem 'httparty'
gem 'jwt'
gem 'pdfkit'
gem 'pg'
gem 'puma', '~> 3.7'
gem 'rack-cors'
gem 'rails', '~> 5.1.5'
gem 'redis'
gem 'roo'
gem 'roo-xls'
gem 'sidekiq'
gem 'uglifier', '>= 1.3.0'
gem 'wkhtmltopdf-binary'
gem "paranoia", "~> 2.2"

group :test do
  gem 'simplecov', :require => false
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'annotate'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'guard-rspec', require: false
  gem 'mock_redis'
  gem 'reek'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
  gem 'rubocop', '~> 0.51.0', require: false
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'webmock'
end

group :development do
  gem 'brakeman', :require => false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'letter_opener'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'bullet'
  gem 'fixture_builder'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
