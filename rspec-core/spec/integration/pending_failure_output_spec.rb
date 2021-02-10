require 'support/aruba_support'

RSpec.describe 'Pending failure output spec' do
  include_context "aruba support"

  it 'by default outputs backtrace and details' do
    write_file 'spec/example_spec.rb', <<-RUBY
    RSpec.describe "something" do
      pending "will never happen again" do
        expect(Time.now.year).to eq(2021)
      end
    end
    RUBY

    run_command ""

    # Then the examples should all pass
    expect(last_cmd_stdout).to include("Pending: (Failures listed here are expected and do not affect your suite's status)")
    expect(last_cmd_stdout).to include("1) something will never happen again")
    expect(last_cmd_stdout).to include("expected: 2021")
    expect(last_cmd_stdout).to include("./spec/example_spec.rb:3")
  end

  it 'setting `pending_failure_output` to `:no_backtrace` hides the backtrace' do
    write_file 'spec/example_spec.rb', <<-RUBY
    RSpec.configure { |c| c.pending_failure_output = :no_backtrace }

    RSpec.describe "something" do
      pending "will never happen again" do
        expect(Time.now.year).to eq(2021)
      end
    end
    RUBY

    run_command ""

    # Then the examples should all pass
    expect(last_cmd_stdout).to include("Pending: (Failures listed here are expected and do not affect your suite's status)")
    expect(last_cmd_stdout).to include("1) something will never happen again")
    expect(last_cmd_stdout).to include("expected: 2021")
    expect(last_cmd_stdout).to_not include("./spec/example_spec.rb:5")
  end

  it 'setting `pending_failure_output` to `:skip` hides the backtrace' do
    write_file 'spec/example_spec.rb', <<-RUBY
    RSpec.configure { |c| c.pending_failure_output = :skip }

    RSpec.describe "something" do
      pending "will never happen again" do
        expect(Time.now.year).to eq(2021)
      end
    end
    RUBY

    run_command ""

    # Then the examples should all pass
    expect(last_cmd_stdout).to_not include("Pending: (Failures listed here are expected and do not affect your suite's status)")
    expect(last_cmd_stdout).to_not include("1) something will never happen again")
    expect(last_cmd_stdout).to_not include("expected: 2021")
    expect(last_cmd_stdout).to_not include("./spec/example_spec.rb:5")
  end
end
