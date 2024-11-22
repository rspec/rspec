source "https://rubygems.org"

%w[rspec rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
  gem lib, :path => File.expand_path("../#{lib}", __FILE__)
end

group :coverage do
  gem 'simplecov'
end

### deps for rdoc.info
group :documentation do
  gem 'github-markup', :platform => :mri
  gem 'redcarpet', :platform => :mri
  gem 'yard', '~> 0.9.24', :require => false
end

platforms :jruby do
  if RUBY_VERSION < '1.9.0'
    # Pin jruby-openssl on older J Ruby
    gem "jruby-openssl", "< 0.10.0"
  else
    gem "jruby-openssl"
  end
end

if RUBY_VERSION.to_f >= 2.4
  gem "aruba", ">= 1.1.0", "< 3.0.0"
else
  gem "aruba", "~> 0.14.10"
end

# This is being extracted in Ruby 3.4 and issues a warning on 3.3
gem 'bigdecimal', :require => false if RUBY_VERSION >= '3.3.0'

gem 'coderay' # for syntax highlighting

gem 'contracts', '< 0.16' if RUBY_VERSION < '1.9.2'

gem 'drb' if RUBY_VERSION >= '3.3'

if RUBY_VERSION < '2.3.0' && !!(RbConfig::CONFIG['host_os'] =~ /cygwin|mswin|mingw|bccwin|wince|emx/)
  gem "childprocess", "< 1.0.0"
elsif RUBY_VERSION < '2.0.0'
  gem "childprocess", "< 1.0.0"
elsif RUBY_VERSION < '2.3.0'
  gem "childprocess", "< 3.0.0"
else
  gem "childprocess", ">= 3.0.0"
end

if RUBY_VERSION < '2.0.0'
  gem 'cucumber', "<= 1.3.22"
else
  gem 'cucumber', ">= 1.3"
end

if ENV['DIFF_LCS_VERSION']
  gem 'diff-lcs', ENV['DIFF_LCS_VERSION']
else
  gem 'diff-lcs', '~> 1.4', '>= 1.4.3'
end

if RUBY_VERSION < '2.2.0' && !!(RbConfig::CONFIG['host_os'] =~ /cygwin|mswin|mingw|bccwin|wince|emx/)
  gem 'ffi', '< 1.10'
elsif RUBY_VERSION < '2.4.0' && !!(RbConfig::CONFIG['host_os'] =~ /cygwin|mswin|mingw|bccwin|wince|emx/)
  gem 'ffi', '< 1.15'
elsif RUBY_VERSION < '2.0'
  gem 'ffi', '< 1.9.19' # ffi dropped Ruby 1.8 support in 1.9.19
elsif RUBY_VERSION < '2.3.0'
  gem 'ffi', '~> 1.12.0'
elsif RUBY_VERSION < '2.6.0'
  gem 'ffi', '~> 1.15.0'
else
  gem 'ffi', '~> 1.17.0'
end

gem "flexmock", "~> 0.9.0"

if RUBY_VERSION < '2.0.0' || RUBY_ENGINE == 'java'
  gem 'json', '< 2.0.0'
else
  gem 'json', '> 2.3.0'
end

# Version 5.12 of minitest requires Ruby 2.4
if RUBY_VERSION < '2.4.0'
  gem 'minitest', '< 5.12.0'
else
  gem 'minitest', '~> 5.12.0'
end

gem "mocha", "~> 0.13.0"

if RUBY_VERSION < '1.9.3'
  gem 'rake', '< 11.0.0' # rake 11 requires Ruby 1.9.3 or later
elsif RUBY_VERSION < '2.0.0'
  gem 'rake', '< 12.0.0' # rake 12 requires Ruby 2.0.0 or later
elsif RUBY_VERSION < '2.2.0'
  gem 'rake', '< 13.0.0' # rake 13 requires Ruby 2.2.0 or later
else
  gem 'rake', '>= 13.0.0'
end

gem "rr", "~> 1.0.4"

# No need to run rubocop on earlier versions
if RUBY_VERSION >= '2.4' && RUBY_ENGINE == 'ruby'
  gem "rubocop", "~> 1.0", "< 1.12"
end

gem 'test-unit', '~> 3.0' if RUBY_VERSION.to_f >= 2.2

gem "thread_order", "~> 1.1.0"

if RUBY_VERSION < '2.0.0'
  gem 'thor', '< 1.0.0'
else
  gem 'thor', '> 1.0.0'
end

eval File.read('Gemfile-custom') if File.exist?('Gemfile-custom')
