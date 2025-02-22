# frozen_string_literal: true

require 'rspec/matchers/built_in/helpers/array_matcher'

module RSpec
  module Matchers
    module BuiltIn
      # @api private
      # Provides the implementation for `match`.
      # Not intended to be instantiated directly.
      class Match < BaseMatcher
        def initialize(expected)
          super(expected)

          @expected_captures = nil
        end
        # @api private
        # @return [String]
        def description
          if @expected_captures && @expected.match(actual)
            "match #{surface_descriptions_in(expected).inspect} with captures #{surface_descriptions_in(@expected_captures).inspect}"
          else
            "match #{surface_descriptions_in(expected).inspect}"
          end
        end

        # @api private
        # @return [Boolean]
        def diffable?
          true
        end

        # Used to specify the captures we match against
        # @return [self]
        def with_captures(*captures)
          @expected_captures = captures
          self
        end

        # @api private
        # @return [String]
        def failure_message
          if Array === expected
            if actual.respond_to?(:to_a) || actual.respond_to?(:to_ary)
              return array_matcher.failure_message
            else
              return "expected a collection that can be converted to an array with " \
                     "`#to_ary` or `#to_a`, but got #{actual_formatted}"
            end
          end

          super
        end

        def matches?(actual)
          @array_matcher = nil
          super(actual)
        end

      private

        def match(expected, actual)
          return match_captures(expected, actual) if @expected_captures
          return true if values_match?(expected, actual)
          return false unless can_safely_call_match?(expected, actual)
          actual.match(expected)
        end

        def can_safely_call_match?(expected, actual)
          return false unless actual.respond_to?(:match)
          return false if Array === expected

          !(RSpec::Matchers.is_a_matcher?(expected) &&
            (String === actual || Regexp === actual))
        end

        def match_captures(expected, actual)
          match = actual.match(expected)
          if match
            match = ReliableMatchData.new(match)
            if match.names.empty?
              values_match?(@expected_captures, match.captures)
            else
              expected_matcher = @expected_captures.last
              values_match?(expected_matcher, Hash[match.names.zip(match.captures)]) ||
                values_match?(expected_matcher, Hash[match.names.map(&:to_sym).zip(match.captures)]) ||
                values_match?(@expected_captures, match.captures)
            end
          else
            false
          end
        end

        def array_matcher
          @array_matcher ||= RSpec::Matchers::BuiltIn::Helpers::ArrayMatcher.new(
            :expected => @expected,
            :actual => @actual,
            :messages => {
              :expected => 'expected collection was',
              :actual => 'actual collection was',
              :missing => 'the missing elements were',
              :extra => 'the extra elements were'
            }
          )
        end
      end

      # @api private
      # Used to wrap match data and make it reliable for 1.8.7
      class ReliableMatchData
        def initialize(match_data)
          @match_data = match_data
        end

        if RUBY_VERSION == "1.8.7"
          # @api private
          # Returns match data names for named captures
          # @return Array
          # :nocov:
          def names
            []
          end
          # :nocov:
        else
          # @api private
          # Returns match data names for named captures
          # @return Array
          def names
            match_data.names
          end
        end

        # @api private
        # returns an array of captures from the match data
        # @return Array
        def captures
          match_data.captures
        end

      protected

        attr_reader :match_data
      end
    end
  end
end
