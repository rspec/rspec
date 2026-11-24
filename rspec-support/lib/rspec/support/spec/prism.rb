# frozen_string_literal: true

require 'rspec/support'

RSpec::Support.require_rspec_support "ruby_features"

module RSpec
  module Support
    module Spec
      # Prism-backed code is only selected at runtime on Rubies that ship Prism
      # as a default gem, but its specs run wherever the prism gem can be
      # loaded so that the code is exercised (and covered) on older Rubies too.
      # JRuby is excluded because, although it reports a 3.3+ RUBY_VERSION, it
      # does not ship the prism gem as a default gem.
      #
      # Searching the load path and installed gems finds Prism without loading
      # it. When RubyGems is disabled, only the load path is searched.
      def self.prism_available?
        return false if Ruby.jruby?
        return Gem.find_files('prism.rb').any? if defined?(::Gem)

        !$LOAD_PATH.resolve_feature_path('prism').nil?
      rescue LoadError
        false
      end
    end
  end
end
