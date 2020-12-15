# frozen_string_literal: true

RSpec::Support.require_rspec_support("method_signature_verifier")

module RSpec
  module Support
    module WithKeywordsWhenNeeded
      # This module adds keyword sensitive support for core ruby methods
      # where we cannot use `ruby2_keywords` directly.

      module_function

      # Remove this in RSpec 4 in favour of explicitly passed in kwargs where
      # this is used. Works around a warning in Ruby 2.7
      def class_exec(klass, *args, &block)
        if MethodSignature.new(block).has_kw_args_in?(args)
          kwargs = args.pop
          klass.class_exec(*args, **kwargs, &block)
        else
          klass.class_exec(*args, &block)
        end
      end
      ruby2_keywords :class_exec if respond_to?(:ruby2_keywords, true)
    end
  end
end
