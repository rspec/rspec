source 'https://rubygems.org'

# Specify your gem's dependencies in rspec-support.gemspec
gemspec

branch = File.read(File.expand_path("../maintenance-branch", __FILE__)).chomp
%w[rspec rspec-core rspec-expectations rspec-mocks].each do |lib|
  library_path = File.expand_path("../../#{lib}", __FILE__)
  if File.exist?(library_path) && !ENV['USE_GIT_REPOS']
    gem lib, :path => library_path
  else
    gem lib, :git => "https://github.com/rspec/#{lib}.git", :branch => branch
  end
end

gem "childprocess", ">= 3.0.0"

### dep for ci/coverage
gem 'simplecov', '~> 0.8'

if RUBY_VERSION < '2.4.0' && !!(RbConfig::CONFIG['host_os'] =~ /cygwin|mswin|mingw|bccwin|wince|emx/)
  gem 'ffi', '< 1.15'
else
  gem 'ffi', '~> 1.15'
end

# No need to run rubocop on earlier versions
if RUBY_VERSION >= '2.4' && RUBY_ENGINE == 'ruby'
  gem 'rubocop', "~> 1.0", "< 1.12"
end

eval_gemfile 'Gemfile-custom' if File.exist?('Gemfile-custom')
