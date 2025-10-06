# frozen_string_literal: true

module RSpec
  module Matchers
    RSpec.describe AliasedMatcher do
      let(:base_matcher_desc) { "my base matcher description" }
      RSpec::Matchers.define :my_base_matcher do
        match { |actual| actual == foo }

        def foo
          13
        end

        def description
          base_matcher_desc
        end
      end
      RSpec::Matchers.alias_matcher :alias_of_my_base_matcher, :my_base_matcher

      it_behaves_like "an RSpec value matcher", :valid_value => 13, :invalid_value => nil do
        let(:matcher) { alias_of_my_base_matcher }
      end

      shared_examples "making a copy" do |copy_method|
        context "when making a copy via `#{copy_method}`" do
          it "uses a copy of the base matcher" do
            base_matcher = include(3)
            aliased = AliasedMatcher.new(base_matcher, Proc.new {})
            copy = aliased.__send__(copy_method)

            expect(copy).not_to equal(aliased)
            expect(copy.base_matcher).not_to equal(base_matcher)
            expect(copy.base_matcher).to be_a(RSpec::Matchers::BuiltIn::Include)
            expect(copy.base_matcher.expected).to eq([3])
          end

          it "copies custom matchers properly so they can work even though they have singleton behavior" do
            base_matcher = my_base_matcher
            aliased = AliasedMatcher.new(base_matcher, Proc.new { |a| a })
            copy = aliased.__send__(copy_method)

            expect(copy).not_to equal(aliased)
            expect(copy.base_matcher).not_to equal(base_matcher)

            expect(13).to copy

            expect { expect(15).to copy }.to fail_with(/expected 15/)
          end
        end
      end

      include_examples "making a copy", :dup
      include_examples "making a copy", :clone

      it 'can get a method object for delegated methods' do
        matcher = my_base_matcher
        decorated = AliasedMatcher.new(matcher, Proc.new {})

        expect(decorated.method(:foo).call).to eq(13)
      end

      it 'can get a method object for `description`' do
        matcher = my_base_matcher
        decorated = AliasedMatcher.new(matcher, Proc.new { "overridden description" })

        expect(decorated.method(:description).call).to eq("overridden description")
      end

      RSpec::Matchers.alias_matcher :my_overridden_matcher, :my_base_matcher do |desc|
        desc + " (overridden)"
      end

      it 'overrides the description with the provided block' do
        matcher = my_overridden_matcher
        expect(matcher.description).to eq("my base matcher description (overridden)")
      end

      RSpec::Matchers.alias_matcher :my_blockless_override, :my_base_matcher

      it 'provides a default description override based on the old and new games' do
        matcher = my_blockless_override
        expect(matcher.description).to eq("my blockless override description")
      end

      context "when the matcher's description starts with the matcher's name" do
        let(:base_matcher_desc) { "my base matcher my base matcher" }

        it 'only overrides the first instance of the name in the description' do
          matcher = alias_of_my_base_matcher
          expect(matcher.description).to eq("alias of my base matcher my base matcher")
        end
      end

      it 'works properly with a chained method off a negated matcher' do
        expect {}.to avoid_outputting.to_stdout

        expect {
          expect { $stdout.puts "a" }.to avoid_outputting.to_stdout
        }.to fail
      end

      class MyKeywordMatcher
        def initialize(**kwargs); end
        def matches?(other); true === other; end
      end

      def my_keyword_matcher(...) = MyKeywordMatcher.new(...)

      RSpec::Matchers.alias_matcher :my_keyword_override, :my_keyword_matcher
      RSpec::Matchers.define_negated_matcher :not_keyword_override, :my_keyword_matcher

      it 'works properly with a keyword arguments matcher' do
        expect(true).to my_keyword_override(some: :arg)
      end

      it 'works properly with a negated keyword arguments matcher' do
        expect(false).to not_keyword_override(some: :arg)
      end

      context "when negating a matcher that does not define `description` (which is an optional part of the matcher protocol)" do
        def matcher_without_description
          matcher = Object.new
          def matcher.matches?(v); v; end
          def matcher.failure_message; "match failed"; end
          def matcher.chained; self; end
          expect(RSpec::Matchers.is_a_matcher?(matcher)).to be true

          matcher
        end

        RSpec::Matchers.define_negated_matcher :negation_of_matcher_without_description, :matcher_without_description

        it 'works properly' do
          expect(true).to matcher_without_description.chained
          expect(false).to negation_of_matcher_without_description.chained
        end
      end
    end
  end
end
