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

      if RUBY_VERSION.to_f >= 2.7
        def supports_taint?
          false
        end
      else
        def supports_taint?
          true
        end
      end

      # Ripper on JRuby 9.0.0.0.rc1 - 9.1.8.0 reports wrong line number
      # or cannot parse source including `:if`.
      # Ripper on JRuby 9.x.x.x < 9.1.17.0 can't handle keyword arguments
      # Neither can JRuby prior to 9.2.1.0
      # TruffleRuby disables ripper due to low performance
      if Ruby.rbx? || Ruby.truffleruby? || (Ruby.jruby? && RSpec::Support::Ruby.jruby_version < '9.2.1.0')
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
