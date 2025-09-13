source "https://rubygems.org"

# Add each library's gemspec
%w[rspec rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
  gem lib, path: "./#{lib}"
end

# Development dependencies for testing and CI
gem 'rake', '>= 13.0.0'

# Test framework dependencies
gem "minitest", "~> 5.12"
gem "test-unit", "~> 3.0"

# Cucumber for feature testing
gem "aruba", "0.14.14"
# FIXME: aruba 1.x and 2.x depend on rspec-expectations ~> 3.4, and this breaks
# gem "aruba", ">= 1.1.0", "< 3.0.0"

# Mock framework support
gem "mocha", "~> 0.13.0"
gem "rr", "~> 3.0.0"
gem "flexmock", "~> 0.9.0"

# Additional utilities
gem "coderay", "~> 1.1.1"
gem "thread_order", "~> 1.1.0"
gem "childprocess", ">= 3.0.0"
gem "thor", "> 1.0.0"

gem 'diff-lcs', '>= 1.4.4', '< 2.0'

gem 'ffi', '~> 1.17.0'

gem "jruby-openssl", platforms: [:jruby]

group :documentation do
  gem 'redcarpet', platform: :mri
  gem 'github-markup', platform: :mri
  # Webrick extracted from Ruby 3.0.0, required by Yard
  gem 'webrick', '~> 1.9.1', :require => false if RUBY_VERSION >= '3.0.0'
  gem 'yard', '~> 0.9.24', :require => false
end

# Coverage dependencies
group :coverage do
  gem 'simplecov'
end

# Linting
gem "rubocop", "~> 1.80", platform: :mri

# Those are bundled gems starting from Ruby 3.4, see https://stdgems.org
if RUBY_VERSION >= "3.4"
  gem 'bigdecimal', :require => false
  gem 'drb'
  gem 'mutex_m', '~> 0.1.0'
end

gem 'json', '> 2.3.0'

# Load custom Gemfile if it exists
eval_gemfile 'Gemfile-custom' if File.exist?('Gemfile-custom')
