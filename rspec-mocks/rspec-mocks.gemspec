# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "rspec/mocks/version"

Gem::Specification.new do |spec|
  spec.name        = "rspec-mocks"
  spec.version     = RSpec::Mocks::Version::STRING
  spec.platform    = Gem::Platform::RUBY
  spec.license     = "MIT"
  spec.authors     = ["Steven Baker", "David Chelimsky", "Myron Marston"]
  spec.email       = "rspec@googlegroups.com"
  spec.homepage    = "https://github.com/rspec/rspec-mocks"
  spec.summary     = "rspec-mocks-#{RSpec::Mocks::Version::STRING}"
  spec.description = "RSpec's 'test double' framework, with support for stubbing and mocking"

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/rspec/rspec/issues',
    'changelog_uri' => "https://github.com/rspec/rspec/blob/rspec-mocks-v#{spec.version}/rspec-mocks/Changelog.md",
    'documentation_uri' => 'https://rspec.info/documentation/',
    'mailing_list_uri' => 'https://groups.google.com/forum/#!forum/rspec',
    'source_code_uri' => "https://github.com/rspec/rspec/blob/rspec-mocks-v#{spec.version}/rspec-mocks",
    'rubygems_mfa_required' => 'true',
  }

  spec.files            = `git ls-files -- lib/*`.split("\n")
  spec.files           += %w[README.md LICENSE.md Changelog.md .yardopts .document]
  spec.test_files       = []
  spec.rdoc_options     = ["--charset=UTF-8"]
  spec.require_path     = "lib"

  spec.required_ruby_version = '>= 1.8.7'

  private_key = File.expand_path('~/.gem/rspec-gem-private_key.pem')
  if File.exist?(private_key)
    spec.signing_key = private_key
    spec.cert_chain = [File.expand_path('~/.gem/rspec-gem-public_cert.pem')]
  end

  if RSpec::Mocks::Version::STRING =~ /[a-zA-Z]+/
    # pin to exact version for rc's and betas
    spec.add_runtime_dependency "rspec-support", "= #{RSpec::Mocks::Version::STRING}"
  else
    # pin to major/minor ignoring patch
    spec.add_runtime_dependency "rspec-support", "~> #{RSpec::Mocks::Version::STRING.split('.')[0..1].concat(['0']).join('.')}"
  end

  spec.add_runtime_dependency "diff-lcs", ">= 1.2.0", "< 2.0"
end
