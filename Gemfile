# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in spyke-connection_lambda.gemspec
gemspec

platform :mri do
  # Debugging
  gem "debug", require: false
end

# Linting
gem "rubocop-lts", "~> 10.1", ">= 10.1.1" # Standardized Linting for Rubies >= 2.3
gem "rubocop-packaging", "~> 0.5", ">= 0.5.2"
gem "rubocop-rspec", "~> 2.10"
