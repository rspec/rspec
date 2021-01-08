# frozen_string_literal: true

require 'rbconfig'
RSpec::Support.require_rspec_support "comparable_version"

module RSpec
  module Support
    # @api private
    #
    # Provides query methods for different OS or OS features.
    module OS
    module_function

      def windows?
        !!(RbConfig::CONFIG['host_os'] =~ /cygwin|mswin|mingw|bccwin|wince|emx/)
      end

      def windows_file_path?
        ::File::ALT_SEPARATOR == '\\'
      end
    end

    # @api private
    #
    # Provides query methods for different rubies
    module Ruby
    module_function

      def jruby?
        RUBY_PLATFORM == 'java'
      end

      def jruby_version
        @jruby_version ||= ComparableVersion.new(JRUBY_VERSION)
      end

      def rbx?
        !!defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
      end

      def mri?
        !defined?(RUBY_ENGINE) || RUBY_ENGINE == 'ruby'
      end

      def truffleruby?
        !!defined?(RUBY_ENGINE) && RUBY_ENGINE == 'truffleruby'
      end
    end

    # @api private
    #
    # Provides query methods for ruby features that differ among
    # implementations.
    module RubyFeatures
    module_function

      def fork_supported?
        Process.respond_to?(:fork)
      end

      if Exception.method_defined?(:detailed_message)
        def supports_exception_detailed_message?
          true
        end
      else
        def supports_exception_detailed_message?
          false
        end
      end

      if RUBY_VERSION.to_f >= 3.2
        def supports_syntax_suggest?
          true
        end
      else
        def supports_syntax_suggest?
          false
        end
      end

      if RUBY_VERSION.to_f >= 3.0
        # https://rubyreferences.github.io/rubychanges/3.0.html#keyword-arguments-are-now-fully-separated-from-positional-arguments
        def kw_arg_separation?
          true
        end
      else
        def kw_arg_separation?
          false
        end
      end

      if RUBY_VERSION.to_f >= 2.7
        def supports_taint?
          false
        end
      else
        def supports_taint?
          true
        end
      end

      # TruffleRuby disables ripper due to low performance
      if Ruby.rbx? || Ruby.truffleruby?
        def ripper_supported?
          false
        end
      else
        def ripper_supported?
          true
        end
      end

      def distincts_kw_args_from_positional_hash?
        RUBY_VERSION >= '3.0.0'
      end
    end
  end
end
