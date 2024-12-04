# -*- encoding: utf-8 -*-
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "rspec/version"

Gem::Specification.new do |spec|
  spec.name        = "rspec"
  spec.version     = RSpec::Version::STRING
  spec.platform    = Gem::Platform::RUBY
  spec.license     = "MIT"
  spec.authors     = ["Steven Baker", "David Chelimsky", "Myron Marston"]
  spec.email       = "rspec@googlegroups.com"
  spec.homepage    = "http://github.com/rspec"
  spec.summary     = "rspec-#{RSpec::Version::STRING}"
  spec.description = "BDD for Ruby"

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/rspec/rspec/issues',
    'documentation_uri' => 'https://rspec.info/documentation/',
    'mailing_list_uri' => 'https://groups.google.com/forum/#!forum/rspec',
    'source_code_uri' => "https://github.com/rspec/rspec/tree/v#{spec.version}",
    'rubygems_mfa_required' => 'true',
  }

  spec.files            = `git ls-files -- lib/*`.split("\n")
  spec.files           += ["LICENSE.md"]
  spec.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  spec.executables      = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.extra_rdoc_files = ["README.md"]
  spec.rdoc_options     = ["--charset=UTF-8"]
  spec.require_path     = "lib"

  private_key = File.expand_path('~/.gem/rspec-gem-private_key.pem')
  if File.exist?(private_key)
    spec.signing_key = private_key
    spec.cert_chain = [File.expand_path('~/.gem/rspec-gem-public_cert.pem')]
  end

  %w[core expectations mocks].each do |name|
    if RSpec::Version::STRING =~ /[a-zA-Z]+/
      spec.add_runtime_dependency "rspec-#{name}", "= #{RSpec::Version::STRING}"
    else
      spec.add_runtime_dependency "rspec-#{name}", "~> #{RSpec::Version::STRING.split('.')[0..1].concat(['0']).join('.')}"
    end
  end
end
