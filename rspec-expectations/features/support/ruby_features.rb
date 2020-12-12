# frozen_string_literal: true

Around "@skip-when-ripper-unsupported" do |scenario, block|
  require 'rspec/support/ruby_features'

  if ::RSpec::Support::RubyFeatures.ripper_supported?
    block.call
  else
    skip_this_scenario "Skipping scenario #{scenario.name} because Ripper is not supported"
  end
end
