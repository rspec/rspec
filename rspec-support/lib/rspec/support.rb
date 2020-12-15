# frozen_string_literal: true

class Thread
  attr_accessor :__rspec_local_data

  class << self
    alias __rspec_current_thread current
  end
end

module RSpec
  module Support
    # @api private
    #
    # Defines a helper method that is optimized to require files from the
    # named lib. The passed block MUST be `{ |f| require_relative f }`
    # because for `require_relative` to work properly from within the named
    # lib the line of code must be IN that lib.
    #
    # `require_relative` is preferred when available because it is always O(1),
    # regardless of the number of dirs in $LOAD_PATH. `require`, on the other
    # hand, does a linear O(N) search over the dirs in the $LOAD_PATH until
    # it can resolve the file relative to one of the dirs.
    def self.define_optimized_require_for_rspec(lib, &require_relative)
      define_singleton_method("require_rspec_#{lib}") do |f|
        require_relative.call("#{lib}/#{f}")
      end
    end

    define_optimized_require_for_rspec(:support) { |f| require_relative(f) }
    require_rspec_support "version"

    # @api private
    KERNEL_METHOD_METHOD = ::Kernel.instance_method(:method)

    # @api private
    #
    # Used internally to get a method handle for a particular object
    # and method name.
    #
    # Includes handling for a few special cases:
    #
    #   - Objects that redefine #method (e.g. an HTTPRequest struct)
    #   - BasicObject subclasses that mixin a Kernel dup (e.g. SimpleDelegator)
    #   - Objects that undefine method and delegate everything to another
    #     object (e.g. Mongoid association objects)
    def self.method_handle_for(object, method_name)
      KERNEL_METHOD_METHOD.bind(object).call(method_name)
    rescue NameError => original
      begin
        handle = object.method(method_name)
        raise original unless handle.is_a? Method
        handle
      rescue Support::AllExceptionsExceptOnesWeMustNotRescue
        raise original
      end
    end

    # @api private
    #
    # Used internally to get a class of a given object, even if it does not respond to #class.
    def self.class_of(object)
      object.class
    rescue NoMethodError
      singleton_class = class << object; self; end
      singleton_class.ancestors.find { |ancestor| !ancestor.equal?(singleton_class) }
    end

    # A single thread local variable so we don't excessively pollute that namespace.
    def self.thread_local_data
      Thread.__rspec_current_thread.__rspec_local_data ||= {}
    end

    # @api private
    def self.failure_notifier=(callable)
      thread_local_data[:failure_notifier] = callable
    end

    # @private
    DEFAULT_FAILURE_NOTIFIER = lambda { |failure, _opts| raise failure }

    # @api private
    def self.failure_notifier
      thread_local_data[:failure_notifier] || DEFAULT_FAILURE_NOTIFIER
    end

    # @api private
    def self.notify_failure(failure, options={})
      failure_notifier.call(failure, options)
    end

    # @api private
    def self.with_failure_notifier(callable)
      orig_notifier = failure_notifier
      self.failure_notifier = callable
      yield
    ensure
      self.failure_notifier = orig_notifier
    end

    class << self
      # @api private
      attr_writer :warning_notifier
    end

    # @private
    DEFAULT_WARNING_NOTIFIER = lambda { |warning| ::Kernel.warn warning }

    # @api private
    def self.warning_notifier
      @warning_notifier ||= DEFAULT_WARNING_NOTIFIER
    end

    # @private
    module AllExceptionsExceptOnesWeMustNotRescue
      # These exceptions are dangerous to rescue as rescuing them
      # would interfere with things we should not interfere with.
      AVOID_RESCUING = [NoMemoryError, SignalException, Interrupt, SystemExit]

      def self.===(exception)
        AVOID_RESCUING.none? { |ar| ar === exception }
      end
    end

    # The Differ is only needed when a spec fails with a diffable failure.
    # In the more common case of all specs passing or the only failures being
    # non-diffable, we can avoid the extra cost of loading the differ, diff-lcs,
    # pp, etc by avoiding an unnecessary require. Instead, autoload will take
    # care of loading the differ on first use.
    autoload :Differ, "rspec/support/differ"
    autoload :HunkGenerator, "rspec/support/hunk_generator"
  end
end
