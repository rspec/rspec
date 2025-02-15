Feature: Diffing

  When appropriate, failure messages will automatically include a diff.

  @skip-when-diff-lcs-1.3 @skip-when-diff-lcs-1.4
  Scenario: Diff for a multiline string
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec.describe "a multiline string" do
        it "is like another string" do
          expected = <<-EXPECTED
      this is the
        expected
          string
      EXPECTED
          actual = <<-ACTUAL
      this is the
        actual
          string
      ACTUAL
          expect(actual).to eq(expected)
        end
      end
      """
    When I run `rspec example_spec.rb`
    Then the output should contain:
      """
             Diff:
             @@ -1,3 +1,3 @@
              this is the
             -  expected
             +  actual
                  string
      """

  @skip-when-diff-lcs-1.3 @skip-when-diff-lcs-1.6
  Scenario: Diff for a multiline string and a regexp on diff-lcs 1.4
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec.describe "a multiline string" do
        it "is like another string" do
          expected = /expected/m
          actual = <<-ACTUAL
      this is the
        actual
          string
      ACTUAL
          expect(actual).to match expected
        end
      end
      """
    When I run `rspec example_spec.rb`
    Then the output should contain:
      """
             Diff:
             @@ -1,3 +1,5 @@
             -/expected/m
             +this is the
             +  actual
             +    string
      """

  @skip-when-diff-lcs-1.4 @skip-when-diff-lcs-1.6
  Scenario: Diff for a multiline string and a regexp on diff-lcs 1.3
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec.describe "a multiline string" do
        it "is like another string" do
          expected = /expected/m
          actual = <<-ACTUAL
      this is the
        actual
          string
      ACTUAL
          expect(actual).to match expected
        end
      end
      """
    When I run `rspec example_spec.rb`
    Then the output should contain:
      """
             Diff:
             @@ -1,2 +1,4 @@
             -/expected/m
             +this is the
             +  actual
             +    string
      """

  Scenario: No diff for a single line strings
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec.describe "a single line string" do
        it "is like another string" do
          expected = "this string"
          actual   = "that string"
          expect(actual).to eq(expected)
        end
      end
      """
    When I run `rspec example_spec.rb`
    Then the output should not contain "Diff:"

  Scenario: No diff for numbers
    Given a file named "example_spec.rb" with:
      """ruby
      RSpec.describe "a number" do
        it "is like another number" do
          expect(1).to eq(2)
        end
      end
      """
    When I run `rspec example_spec.rb`
    Then the output should not contain "Diff:"
