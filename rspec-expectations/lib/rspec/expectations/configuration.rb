# frozen_string_literal: true

module RSpec
  module Expectations
    # Provides configuration options for rspec-expectations.
    # If you are using rspec-core, you can access this via a
    # block passed to `RSpec::Core::Configuration#expect_with`.
    # Otherwise, you can access it via RSpec::Expectations.configuration.
    #
    # @example
    #   RSpec.configure do |rspec|
    #     rspec.expect_with :rspec do |c|
    #       # c is the config object
    #     end
    #   end
    #
    #   # or
    #
    #   RSpec::Expectations.configuration
    class Configuration
      # @private
      FALSE_POSITIVE_BEHAVIOURS =
        {
          :warn    => lambda { |message| RSpec.warning message },
          :raise   => lambda { |message| raise ArgumentError, message },
          :nothing => lambda { |_| true },
        }

      def initialize
        @on_potential_false_positives = :warn
        @strict_predicate_matchers = true
      end

      # Configures the maximum character length that RSpec will print while
      # formatting an object. You can set length to nil to prevent RSpec from
      # doing truncation.
      # @param [Fixnum] length the number of characters to limit the formatted output to.
      # @example
      #   RSpec.configure do |rspec|
      #     rspec.expect_with :rspec do |c|
      #       c.max_formatted_output_length = 200
      #     end
      #   end
      def max_formatted_output_length=(length)
        RSpec::Support::ObjectFormatter.default_instance.max_formatted_output_length = length
      end

      if ::RSpec.respond_to?(:configuration)
        def color?
          ::RSpec.configuration.color_enabled?
        end
      else
        # :nocov:
        # Indicates whether or not diffs should be colored.
        # Delegates to rspec-core's color option if rspec-core
        # is loaded; otherwise you can set it here.
        attr_writer :color

        # Indicates whether or not diffs should be colored.
        # Delegates to rspec-core's color option if rspec-core
        # is loaded; otherwise you can set it here.
        def color?
          defined?(@color) && @color
        end
        # :nocov:
      end

      # Sets or gets the backtrace formatter. The backtrace formatter should
      # implement `#format_backtrace(Array<String>)`. This is used
      # to format backtraces of errors handled by the `raise_error`
      # matcher.
      #
      # If you are using rspec-core, rspec-core's backtrace formatting
      # will be used (including respecting the presence or absence of
      # the `--backtrace` option).
      #
      # @!attribute [rw] backtrace_formatter
      attr_writer :backtrace_formatter
      def backtrace_formatter
        @backtrace_formatter ||= if defined?(::RSpec.configuration.backtrace_formatter)
                                   ::RSpec.configuration.backtrace_formatter
                                 else
                                   NullBacktraceFormatter
                                 end
      end

      # @api private
      # Null implementation of a backtrace formatter used by default
      # when rspec-core is not loaded. Does no filtering.
      NullBacktraceFormatter = Module.new do
        def self.format_backtrace(backtrace)
          backtrace
        end
      end

      # Configures whether RSpec will warn about matcher use which will
      # potentially cause false positives in tests.
      #
      # @param [Boolean] boolean
      # @deprecated Use {#on_potential_false_positives=} which supports :warn, :raise, and :nothing behaviors
      def warn_about_potential_false_positives=(boolean)
        RSpec.deprecate(
          "warn_about_potential_false_positives=",
          :replacement => "`on_potential_false_positives=` which supports :warn, :raise, and :nothing behaviors"
        )
        if boolean
          self.on_potential_false_positives = :warn
        elsif warn_about_potential_false_positives?
          self.on_potential_false_positives = :nothing
        else
          # no-op, handler is something else
        end
      end

      # Configures what RSpec will do about matcher use which would potentially cause
      # false positives in tests. Defaults to `:warn` since this is generally the desired behavior,
      # but can also be set to `:raise` or `:nothing`.
      #
      # @overload on_potential_false_positives
      #   @return [Symbol] the behavior setting
      # @overload on_potential_false_positives=(value)
      #   @param [Symbol] behavior can be set to `:warn`, `:raise` or `:nothing`
      #   @return [Symbol] the behavior setting
      attr_reader :on_potential_false_positives

      def on_potential_false_positives=(behavior)
        unless FALSE_POSITIVE_BEHAVIOURS.key?(behavior)
          raise ArgumentError, "Supported values are: #{FALSE_POSITIVE_BEHAVIOURS.keys}"
        end
        @on_potential_false_positives = behavior
      end

      # Configures RSpec to check predicate matchers to `be(true)` / `be(false)` (strict),
      # or `be_truthy` / `be_falsey` (not strict).
      # Historically, the default was `false`, but `true` is recommended.
      #
      # @overload strict_predicate_matchers
      #   @return [Boolean]
      # @overload strict_predicate_matchers?
      #   @return [Boolean]
      # @overload strict_predicate_matchers=(value)
      #   @param [Boolean] value
      attr_reader :strict_predicate_matchers

      def strict_predicate_matchers=(value)
        raise ArgumentError, "Pass `true` or `false`" unless value == true || value == false
        @strict_predicate_matchers = value
      end

      def strict_predicate_matchers?
        @strict_predicate_matchers
      end

      # Indicates whether RSpec will warn about matcher use which will
      # potentially cause false positives in tests, generally you want to
      # avoid such scenarios so this defaults to `true`.
      # @deprecated Use {#on_potential_false_positives} which supports :warn, :raise, and :nothing behaviors
      def warn_about_potential_false_positives?
        RSpec.deprecate(
          "warn_about_potential_false_positives?",
          :replacement => "`on_potential_false_positives` which supports :warn, :raise, and :nothing behaviors"
        )
        on_potential_false_positives == :warn
      end

      # @private
      def false_positives_handler
        FALSE_POSITIVE_BEHAVIOURS.fetch(@on_potential_false_positives)
      end
    end

    # The configuration object.
    # @return [RSpec::Expectations::Configuration] the configuration object
    def self.configuration
      @configuration ||= Configuration.new
    end
  end
end
