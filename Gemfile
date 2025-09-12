source "https://rubygems.org"

# Add each library's gemspec
%w[rspec rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
  gem lib, path: "./#{lib}"
end

# Development dependencies for testing and CI
gem "rake", ">= 12.3.3"

# Test framework dependencies
gem "minitest", "~> 5.2"
gem "test-unit", "~> 3.0"

# Cucumber for feature testing
gem 'cucumber', '>= 3.2', '!= 4.0.0', '< 8.0.0'
gem 'aruba', '~> 0.14.9'

# Mock framework support
gem "mocha", "~> 0.13.0"
gem "rr", "~> 3.0.0"
gem "flexmock", "~> 0.9.0"

# Additional utilities
gem "coderay", "~> 1.1.1"
gem "thread_order", "~> 1.1.0"
gem "childprocess", ">= 3.0.0"
gem "thor", "> 1.0.0"

# Platform-specific dependencies
if RUBY_VERSION < '2.4.0' && !!(RbConfig::CONFIG['host_os'] =~ /cygwin|mswin|mingw|bccwin|wince|emx/)
  gem 'ffi', '< 1.15'
else
  gem 'ffi', '~> 1.15'
end

gem "jruby-openssl", platforms: [:jruby]

# Version 5.12 of minitest requires Ruby 2.4
if RUBY_VERSION < '2.4.0'
  gem 'minitest', '< 5.12.0'
end

# Documentation dependencies
gem 'yard', '~> 0.9.24', require: false

group :documentation do
  gem 'redcarpet', platform: :mri
  gem 'github-markup', platform: :mri
end

# Coverage dependencies
group :coverage do
  gem 'simplecov', '~> 0.8'
end

# Linting (only on supported Ruby versions)
if RUBY_VERSION >= '2.4' && RUBY_ENGINE == 'ruby'
  gem "rubocop", "~> 1.0", "< 1.12"
end

# Load custom Gemfile if it exists
eval_gemfile 'Gemfile-custom' if File.exist?('Gemfile-custom')
