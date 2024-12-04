# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "rspec/expectations/version"

Gem::Specification.new do |spec|
  spec.name        = "rspec-expectations"
  spec.version     = RSpec::Expectations::Version::STRING
  spec.platform    = Gem::Platform::RUBY
  spec.license     = "MIT"
  spec.authors     = ["Steven Baker", "David Chelimsky", "Myron Marston"]
  spec.email       = "rspec@googlegroups.com"
  spec.homepage    = "https://github.com/rspec/rspec-expectations"
  spec.summary     = "rspec-expectations-#{RSpec::Expectations::Version::STRING}"
  spec.description = "rspec-expectations provides a simple, readable API to express expected outcomes of a code example."

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/rspec/rspec/issues',
    'changelog_uri' => "https://github.com/rspec/rspec/blob/rspec-expectations-v#{spec.version}/rspec-expectations/Changelog.md",
    'documentation_uri' => 'https://rspec.info/documentation/',
    'mailing_list_uri' => 'https://groups.google.com/forum/#!forum/rspec',
    'source_code_uri' => "https://github.com/rspec/rspec/blob/rspec-expectations-v#{spec.version}/rspec-expectations",
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

  if RSpec::Expectations::Version::STRING =~ /[a-zA-Z]+/
    # pin to exact version for rc's and betas
    spec.add_runtime_dependency "rspec-support", "= #{RSpec::Expectations::Version::STRING}"
  else
    # pin to major/minor ignoring patch
    spec.add_runtime_dependency "rspec-support", "~> #{RSpec::Expectations::Version::STRING.split('.')[0..1].concat(['0']).join('.')}"
  end

  spec.add_runtime_dependency "diff-lcs", ">= 1.2.0", "< 2.0"
end
