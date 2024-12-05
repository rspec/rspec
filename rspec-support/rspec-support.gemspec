# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/support/version'

Gem::Specification.new do |s|
  s.name          = "rspec-support"
  s.version       = RSpec::Support::Version::STRING
  s.authors       = ["David Chelimsky","Myron Marson","Jon Rowe","Sam Phippen","Xaviery Shay","Bradley Schaefer"]
  s.email         = "rspec-users@rubyforge.org"
  s.homepage      = "https://rspec.info"
  s.summary       = "rspec-support-#{RSpec::Support::Version::STRING}"
  s.description   = "Support utilities for RSpec gems"
  s.license       = "MIT"

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/rspec/rspec/issues',
    'changelog_uri' => "https://github.com/rspec/rspec/tree/rspec-support-v#{s.version}/rspec-support/Changelog.md",
    'documentation_uri' => 'https://rspec.info/documentation/',
    'mailing_list_uri' => 'https://groups.google.com/forum/#!forum/rspec',
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => "https://github.com/rspec/rspec/tree/rspec-support-v#{s.version}/rspec-support",
  }

  s.files         = `git ls-files -- lib/*`.split("\n")
  s.files         += %w[README.md LICENSE.md Changelog.md]
  s.test_files    = []
  s.rdoc_options  = ["--charset=UTF-8"]
  s.require_paths = ["lib"]

  private_key = File.expand_path('~/.gem/rspec-gem-private_key.pem')
  if File.exist?(private_key)
    s.signing_key = private_key
    s.cert_chain = [File.expand_path('~/.gem/rspec-gem-public_cert.pem')]
  end

  s.required_ruby_version = '>= 1.8.7'
end
