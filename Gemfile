# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'active_service', github: 'khanhvancong/active_service'

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'simplecov-json'
end

group :development do
  gem 'rubocop'
  gem 'rubocop-performance'
end

group :development, :test do
  gem 'dotenv'
end

gemspec
