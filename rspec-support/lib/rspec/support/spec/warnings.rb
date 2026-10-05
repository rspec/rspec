# frozen_string_literal: true

RSpec::Support.require_rspec_support "ruby_features"

module RSpec
  module Support
    module Spec
      module Warnings
        if RUBY_VERSION.to_f > 2.6
          SUPPORTED_WARNINGS =
            [
              :deprecated,
              :experimental
            ]
          SUPPORTED_WARNINGS << :strict_unused_block if RUBY_VERSION.to_f >= 3.4 && !RSpec::Support::Ruby.jruby?
          SUPPORTED_WARNINGS.freeze

          def self.setup
            SUPPORTED_WARNINGS.each do |flag|
              Warning[flag] = true
            end
          end
        else
          def self.setup
            # Skip this check on Ruby 2.6 and below
          end
        end
      end
    end
  end
end
