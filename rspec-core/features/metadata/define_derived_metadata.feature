Feature: Deriving metadata

  You can use `config.define_derived_metadata` to assign metadata to groups and
  examples based on their existing metadata. The block you provide is passed the
  metadata hash of each matching group or example, which you can mutate in place.

  Pass one or more filters to limit which groups and examples the block is
  applied to. A filter can be a hash (such as `:file_path => /regex/`) or a
  symbol (which matches any group or example with that metadata key set to a
  truthy value). When no filter is given, the block is applied to every group
  and example.

  Derived metadata is applied in cascade: if a block assigns metadata that
  matches the filter of another block, that block is applied as well.

  Scenario: Apply derived metadata to every group and example
    Given a file named "derive_for_everything_spec.rb" with:
      """ruby
      RSpec.configure do |config|
        config.define_derived_metadata do |metadata|
          metadata[:reviewed] = true
        end
      end

      RSpec.describe "a group with no metadata of its own" do
        it "has the derived metadata" do |example|
          expect(example.metadata[:reviewed]).to be(true)
        end
      end
      """
    When I run `rspec derive_for_everything_spec.rb`
    Then the examples should all pass

  Scenario: Apply derived metadata only to matching examples
    Given a file named "derive_with_filter_spec.rb" with:
      """ruby
      RSpec.configure do |config|
        config.define_derived_metadata(:slow) do |metadata|
          metadata[:timeout] = 10
        end
      end

      RSpec.describe "deriving metadata from a filter" do
        it "applies to matching examples", :slow do |example|
          expect(example.metadata[:timeout]).to eq(10)
        end

        it "leaves non-matching examples untouched" do |example|
          expect(example.metadata).not_to include(:timeout)
        end
      end
      """
    When I run `rspec derive_with_filter_spec.rb`
    Then the examples should all pass

  Scenario: Derive metadata from a file location
    Given a file named "spec/unit/calculator_spec.rb" with:
      """ruby
      RSpec.configure do |config|
        # Tag everything under spec/unit as a unit test.
        config.define_derived_metadata(:file_path => %r{/spec/unit/}) do |metadata|
          metadata[:type] = :unit
        end
      end

      RSpec.describe "a spec living under spec/unit" do
        it "is tagged with the derived type" do |example|
          expect(example.metadata[:type]).to eq(:unit)
        end
      end
      """
    When I run `rspec spec/unit/calculator_spec.rb`
    Then the examples should all pass

  Scenario: Derived metadata cascades to other matching blocks
    Given a file named "derive_in_cascade_spec.rb" with:
      """ruby
      RSpec.configure do |config|
        config.define_derived_metadata(:needs_db) do |metadata|
          metadata[:slow] = true
        end

        config.define_derived_metadata(:slow) do |metadata|
          metadata[:timeout] = 30
        end
      end

      RSpec.describe "cascading derived metadata" do
        it "triggers blocks for metadata derived by earlier blocks", :needs_db do |example|
          expect(example.metadata[:slow]).to be(true)
          expect(example.metadata[:timeout]).to eq(30)
        end
      end
      """
    When I run `rspec derive_in_cascade_spec.rb`
    Then the examples should all pass
