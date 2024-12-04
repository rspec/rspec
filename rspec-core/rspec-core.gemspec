# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "rspec/core/version"

Gem::Specification.new do |spec|
  spec.name        = "rspec-core"
  spec.version     = RSpec::Core::Version::STRING
  spec.platform    = Gem::Platform::RUBY
  spec.license     = "MIT"
  spec.authors     = ["Steven Baker", "David Chelimsky", "Chad Humphries", "Myron Marston"]
  spec.email       = "rspec@googlegroups.com"
  spec.homepage    = "https://github.com/rspec/rspec-core"
  spec.summary     = "rspec-core-#{RSpec::Core::Version::STRING}"
  spec.description = "BDD for Ruby. RSpec runner and example groups."

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/rspec/rspec/issues',
    'changelog_uri' => "https://github.com/rspec/rspec/blob/rspec-core-v#{spec.version}/rspec-core/Changelog.md",
    'documentation_uri' => 'https://rspec.info/documentation/',
    'mailing_list_uri' => 'https://groups.google.com/forum/#!forum/rspec',
    'source_code_uri' => "https://github.com/rspec/rspec/blob/rspec-core-v#{spec.version}/rspec-core",
    'rubygems_mfa_required' => 'true',
  }

  spec.files            = `git ls-files -- lib/*`.split("\n")
  spec.files           += %w[README.md LICENSE.md Changelog.md .yardopts .document]
  spec.test_files       = []
  spec.bindir           = 'exe'
  spec.executables      = `git ls-files -- exe/*`.split("\n").map{ |f| File.basename(f) }
  spec.rdoc_options     = ["--charset=UTF-8"]
  spec.require_path     = "lib"

  spec.required_ruby_version = '>= 1.8.7'

  private_key = File.expand_path('~/.gem/rspec-gem-private_key.pem')
  if File.exist?(private_key)
    spec.signing_key = private_key
    spec.cert_chain = [File.expand_path('~/.gem/rspec-gem-public_cert.pem')]
  end

  if RSpec::Core::Version::STRING =~ /[a-zA-Z]+/
    # rspec-support is locked to our version when running pre,rc etc
    spec.add_runtime_dependency "rspec-support", "= #{RSpec::Core::Version::STRING}"
  else
    # rspec-support must otherwise match our major/minor version
    spec.add_runtime_dependency "rspec-support", "~> #{RSpec::Core::Version::STRING.split('.')[0..1].concat(['0']).join('.')}"
  end
end
