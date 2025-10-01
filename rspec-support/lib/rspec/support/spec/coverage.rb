# frozen_string_literal: true

require 'rspec/support'

RSpec::Support.require_rspec_support "ruby_features"

module RSpec
  module Support
    module Spec
      module Coverage
        def self.setup(&block)
          # Simplecov emits some ruby warnings when loaded, so silence them.
          old_verbose, $VERBOSE = $VERBOSE, false

          return if ENV['NO_COVERAGE']
          return if RUBY_ENGINE != 'ruby' || RSpec::Support::OS.windows?

          # Don't load it when we're running a single isolated
          # test file rather than the whole suite.
          #
          # The extra defined check is so that script/rspec_with_simplecov can reuse
          # this logic.
          return if defined?(RSpec.configuration) && RSpec.configuration.files_to_run.one?

          require 'simplecov'
          start(&block)
        rescue LoadError
          warn "Simplecov could not be loaded"
        ensure
          $VERBOSE = old_verbose
        end

        def self.start(&block)
          SimpleCov.start do
            add_filter "bundle/"
            add_filter "tmp/"
            add_filter do |source_file|
              # Filter out `spec` directory except when it is under `lib`
              # (as is the case in rspec-support)
              source_file.filename.include?('/spec/') && !source_file.filename.include?('/lib/')
            end

            instance_eval(&block) if block
          end
        end
        private_class_method :start
      end
    end
  end
end
