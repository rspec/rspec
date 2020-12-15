# frozen_string_literal: true

module RSpec
  module Support
    # Provides recursive constant lookup methods useful for
    # constant stubbing.
    module RecursiveConstMethods
      # We only want to consider constants that are defined directly on a
      # particular module, and not include top-level/inherited constants.
      #
      # Given:
      #   class A; B = 1; end
      #   class C < A; end
      #
      # Then:
      #   C.const_get("Hash") # => ::Hash
      #   C.const_defined?("Hash") # => true
      #   C.const_get("Hash", false) # => raises NameError
      #   C.const_defined?("Hash", false) # => false
      #   C.constants # => [:B]
      #   C.constants(false) #=> []

      def const_defined_on?(mod, const_name)
        mod.const_defined?(const_name, false)
      end

      def get_const_defined_on(mod, const_name)
        mod.const_get(const_name, false)
      end

      def constants_defined_on(mod)
        mod.constants(false)
      end

      def recursive_const_get(const_name)
        normalize_const_name(const_name).split('::').inject(Object) do |mod, name|
          get_const_defined_on(mod, name)
        end
      end

      def recursive_const_defined?(const_name)
        parts = normalize_const_name(const_name).split('::')
        parts.inject([Object, '']) do |(mod, full_name), name|
          yield(full_name, name) if block_given? && !(Module === mod)
          return false unless const_defined_on?(mod, name)
          [get_const_defined_on(mod, name), [mod.name, name].join('::')]
        end
      end

      def normalize_const_name(const_name)
        const_name.sub(/\A::/, '')
      end
    end
  end
end
