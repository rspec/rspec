# frozen_string_literal: true

Around "@skip-when-parser-unsupported" do |scenario, block|
  require 'rspec/support/ruby_features'

  if ::RSpec::Support::RubyFeatures.parser_supported?
    block.call
  else
    skip_this_scenario "Skipping scenario #{scenario.name} because no parser is supported"
  end
end
