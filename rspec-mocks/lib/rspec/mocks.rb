require 'rspec/mocks/framework'
require 'rspec/mocks/version'

module RSpec

  module Mocks
    class << self
      attr_accessor :space
    end

    def self.setup(host)
      self.space ||= RSpec::Mocks::Space.new
    end

    def self.verify
      space.verify_all
    end

    def self.teardown
      space.reset_all
    end

    def self.proxy_for(object)
      space.proxy_for(object)
    end

    def self.proxies_of(klass)
      space.proxies_of(klass)
    end

    def self.any_instance_recorder_for(klass)
      space.any_instance_recorder_for(klass)
    end

    # Adds an allowance (stub) on `subject`
    #
    # @param subject the subject to which the message will be added
    # @param message a symbol, representing the message that will be
    #                added.
    # @param opts a hash of options, :expected_from is used to set the
    #             original call site
    # @param block an optional implementation for the allowance
    #
    # @example Defines the implementation of `foo` on `bar`, using the passed block
    #   x = 0
    #   RSpec::Mocks.allow_message(bar, :foo) { x += 1 }
    def self.allow_message(subject, message, opts={}, &block)
      orig_caller = opts.fetch(:expected_from) {
        CallerFilter.first_non_rspec_line
      }
      ::RSpec::Mocks.proxy_for(subject).
        add_stub(orig_caller, message, opts, &block)
    end

    # Sets a message expectation on `subject`.
    # @param subject the subject on which the message will be expected
    # @param message a symbol, representing the message that will be
    #                expected.
    # @param opts a hash of options, :expected_from is used to set the
    #             original call site
    # @param block an optional implementation for the expectation
    #
    # @example Expect the message `foo` to receive `bar`, then call it
    #   RSpec::Mocks.expect_message(bar, :foo)
    #   bar.foo
    def self.expect_message(subject, message, opts={}, &block)
      orig_caller = opts.fetch(:expected_from) {
        CallerFilter.first_non_rspec_line
      }
      ::RSpec::Mocks.proxy_for(subject).
        add_message_expectation(orig_caller, message, opts, &block)
    end

    # @api private
    KERNEL_METHOD_METHOD = ::Kernel.instance_method(:method)

    # @api private
    # Used internally to get a method handle for a particular object
    # and method name.
    #
    # Includes handling for a few special cases:
    #
    #   - Objects that redefine #method (e.g. an HTTPRequest struct)
    #   - BasicObject subclasses that mixin a Kernel dup (e.g. SimpleDelegator)
    def self.method_handle_for(object, method_name)
      if ::Kernel === object
        KERNEL_METHOD_METHOD.bind(object).call(method_name)
      else
        object.method(method_name)
      end
    end

    # @private
    IGNORED_BACKTRACE_LINE = 'this backtrace line is ignored'
  end
end

