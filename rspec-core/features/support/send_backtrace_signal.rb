# Sends the platform's backtrace signal (SIGINFO or SIGPWR) to the current
# process after a short delay, so that RSpec's thread dump handler runs
# during the suite. Used by the siginfo_sigpwr feature.
require 'rspec/core'

backtrace_signal = RSpec::Core::Runner.send(:backtrace_signal)

if backtrace_signal
  RSpec.configure do |config|
    config.before(:each) do
      @thread = Thread.new do
        sleep 0.5
        Process.kill(backtrace_signal, Process.pid)
      end
    end

    config.after(:each) do
      @thread&.kill
    end
  end
end
