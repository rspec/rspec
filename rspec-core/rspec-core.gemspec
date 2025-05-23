# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "rspec/core/version"

Gem::Specification.new do |s|
  s.name        = "rspec-core"
  s.version     = RSpec::Core::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.authors     = ["Steven Baker", "David Chelimsky", "Chad Humphries", "Myron Marston"]
  s.email       = "rspec@googlegroups.com"
  s.homepage    = "https://rspec.info"
  s.summary     = "rspec-core-#{RSpec::Core::Version::STRING}"
  s.description = "BDD for Ruby. RSpec runner and example groups."

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/rspec/rspec/issues',
    'changelog_uri' => "https://github.com/rspec/rspec/blob/rspec-core-v#{s.version}/rspec-core/Changelog.md",
    'documentation_uri' => 'https://rspec.info/documentation/',
    'mailing_list_uri' => 'https://groups.google.com/forum/#!forum/rspec',
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => "https://github.com/rspec/rspec/blob/rspec-core-v#{s.version}/rspec-core",
  }

  s.files            = `git ls-files -- lib/*`.split("\n")
  s.files           += %w[README.md LICENSE.md Changelog.md .yardopts .document]
  s.test_files       = []
  s.bindir           = 'exe'
  s.executables      = ['rspec']
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"

  s.required_ruby_version = '>= 1.8.7'

  private_key = File.expand_path('~/.gem/rspec-gem-private_key.pem')
  if File.exist?(private_key)
    s.signing_key = private_key
    s.cert_chain = [File.expand_path('~/.gem/rspec-gem-public_cert.pem')]
  end

  if RSpec::Core::Version::STRING =~ /[a-zA-Z]+/
    # rspec-support is locked to our version when running pre,rc etc
    s.add_runtime_dependency "rspec-support", "= #{RSpec::Core::Version::STRING}"
  else
    # rspec-support must otherwise match our major/minor version
    s.add_runtime_dependency "rspec-support", "~> #{RSpec::Core::Version::STRING.split('.')[0..1].concat(['0']).join('.')}"
  end
end
