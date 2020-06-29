RSpec::Support.require_rspec_core "formatters/bisect_progress_formatter"

module RSpec::Core
  RSpec.describe "Bisect", :slow, :simulate_shell_allowing_unquoted_ids do
    include FormatterSupport

    before do
      skip "These specs do not consistently pass or fail on AppVeyor on Ruby 2.1+"
    end if ENV['APPVEYOR'] && RUBY_VERSION.to_f > 2.0

    def bisect(cli_args, expected_status=nil)
      options = ConfigurationOptions.new(cli_args)

      expect {
        status = Invocations::Bisect.new.call(options, formatter_output, formatter_output)
        expect(status).to eq(expected_status) if expected_status
      }.to avoid_outputting.to_stdout_from_any_process.and avoid_outputting.to_stderr_from_any_process

      normalize_durations(formatter_output.string)
    end

    context "when a load-time problem occurs while running the suite" do
      it 'surfaces the stdout and stderr output to the user' do
        output = bisect(%w[spec/rspec/core/resources/fail_on_load_spec.rb_], 1)
        expect(output).to include("Bisect failed!", "undefined method `contex'", "About to call misspelled method")
      end
    end

    context "when the spec ordering is inconsistent" do
      it 'stops bisecting and surfaces the problem to the user' do
        output = bisect(%W[spec/rspec/core/resources/inconsistently_ordered_specs.rb], 1)
        expect(output).to include("Bisect failed!", "The example ordering is inconsistent")
      end
    end

    context "when the bisect command saturates the pipe" do
      # On OSX and Linux a file descriptor limit meant that the bisect process got stuck at a certain limit.
      # This test demonstrates that we can run large bisects above this limit (found to be at time of commit).
      # See: https://github.com/rspec/rspec-core/pull/2669
      it 'does not hit pipe size limit and does not get stuck' do
        output = bisect(%W[spec/rspec/core/resources/blocking_pipe_bisect_spec.rb_], 1)
        expect(output).to include("No failures found.")
      end

      it 'does not leave zombie processes', :unless => RSpec::Support::OS.windows? do
        original_pids = pids()
        bisect(%W[spec/rspec/core/resources/blocking_pipe_bisect_spec.rb_], 1)
        cursor = 0
        while ((extra_pids = pids() - original_pids).join =~ /[RE]/i)
          raise "Extra process detected" if cursor > 10
          cursor += 1
          sleep 0.1
        end
        expect(extra_pids.join).to_not include "Z"
      end
    end

    def pids
      %x[ps -ho pid,state,cmd | grep "[r]uby"].split("\n").map do |line|
        line.split(/\s+/).compact.join(' ')
      end
    end
  end
end
