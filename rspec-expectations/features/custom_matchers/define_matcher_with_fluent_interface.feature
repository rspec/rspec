Feature: Defining a matcher with fluent interface

  Use the `chain` method to define matchers with a fluent interface.

  Scenario: Chained method with argument
    Given a file named "between_spec.rb" with:
      """ruby
      RSpec::Matchers.define :be_bigger_than do |first|
        match do |actual|
          (actual > first) && (actual < @second)
        end

        chain :and_smaller_than do |second|
          @second = second
        end
      end

      RSpec.describe "Integer" do
        subject(:number) { 5 }

        it { is_expected.to be_bigger_than(4).and_smaller_than(6) }
      end
      """
    When I run `rspec between_spec.rb --format documentation`
    Then the output should contain "1 example, 0 failures"
    And  the output should contain "is expected to be bigger than 4"

  Scenario: Chained setter
    Given a file named "between_spec.rb" with:
      """ruby
      RSpec::Matchers.define :be_bigger_than do |first|
        match do |actual|
          (actual > first) && (actual < second)
        end

        chain :and_smaller_than, :second
      end

      RSpec.describe "Integer" do
        subject(:number) { 5 }

        it { is_expected.to be_bigger_than(4).and_smaller_than(6) }
      end
      """
    When I run `rspec between_spec.rb --format documentation`
    Then the output should contain "1 example, 0 failures"
    And  the output should contain "is expected to be bigger than 4"

    Scenario: With `include_chain_clauses_in_custom_matcher_descriptions` configured to true, and chained method with argument
      Given a file named "between_spec.rb" with:
        """ruby
        RSpec.configure do |config|
          config.expect_with :rspec do |c|
            c.include_chain_clauses_in_custom_matcher_descriptions = true
          end
        end

        RSpec::Matchers.define :be_bigger_than do |first|
          match do |actual|
            (actual > first) && (actual < @second)
          end

          chain :and_smaller_than do |second|
            @second = second
          end
        end

        RSpec.describe "Integer" do
        subject(:number) { 5 }

          it { is_expected.to be_bigger_than(4).and_smaller_than(6) }
        end
        """
      When I run `rspec between_spec.rb --format documentation`
      Then the output should contain "1 example, 0 failures"
      And  the output should contain "is expected to be bigger than 4 and smaller than 6"
