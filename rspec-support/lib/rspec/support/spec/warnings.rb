# frozen_string_literal: true

RSpec::Support.require_rspec_support "ruby_features"

module RSpec
  module Support
    module Spec
      module Warnings
        SUPPORTED_WARNINGS =
          %i[
            deprecated
            experimental
          ]
        SUPPORTED_WARNINGS << :strict_unused_block if RUBY_VERSION.to_f >= 3.4 && !RSpec::Support::Ruby.jruby?
        SUPPORTED_WARNINGS.freeze

        def self.setup
          SUPPORTED_WARNINGS.each do |flag|
            Warning[flag] = true
          end
        end
      end
    end
  end
end
