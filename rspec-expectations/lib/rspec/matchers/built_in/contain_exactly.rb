# frozen_string_literal: true

require 'rspec/matchers/built_in/helpers/array_matcher'

module RSpec
  module Matchers
    module BuiltIn
      # @api private
      # Provides the implementation for `contain_exactly` and `match_array`.
      # Not intended to be instantiated directly.
      class ContainExactly < BaseMatcher
        # @api private
        # @return [String]
        def failure_message
          if Array === actual
            array_matcher.failure_message
          else
            "expected a collection that can be converted to an array with " \
              "`#to_ary` or `#to_a`, but got #{actual_formatted}"
          end
        end

        # @api private
        # @return [String]
        def failure_message_when_negated
          list = EnglishPhrasing.list(surface_descriptions_in(expected))
          "expected #{actual_formatted} not to contain exactly#{list}"
        end

        # @api private
        # @return [String]
        def description
          list = EnglishPhrasing.list(surface_descriptions_in(expected))
          "contain exactly#{list}"
        end

        def matches?(actual)
          @array_matcher = nil
          super(actual)
        end

      private

        def array_matcher
          # Avoid warnings in Ruby 2.7
          @expected ||= nil
          @actual ||= nil

          @array_matcher ||= RSpec::Matchers::BuiltIn::Helpers::ArrayMatcher.new(
            :expected => @expected,
            :actual => @actual,
            :messages => {
              :expected => 'expected collection contained',
              :actual => 'actual collection contained',
              :missing => 'the missing elements were',
              :extra => 'the extra elements were'
            },
            :display_array => ->(array) { safe_sort(array) }
          )
        end

        def actual
          array_matcher.actual
        end

        def expected
          array_matcher.expected
        end

        def match(_expected, _actual)
          return false unless actual
          match_when_sorted? || array_matcher.elements_match?
        end

        # This cannot always work (e.g. when dealing with unsortable items,
        # or matchers as expected items), but it's practically free compared to
        # the slowness of the full matching algorithm, and in common cases this
        # works, so it's worth a try.
        def match_when_sorted?
          values_match?(safe_sort(expected), safe_sort(actual))
        end

        def safe_sort(array)
          array.sort
        rescue Support::AllExceptionsExceptOnesWeMustNotRescue
          array
        end
      end
    end
  end
end
