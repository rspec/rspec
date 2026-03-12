Feature: Thread dump on SIGINFO / SIGPWR

  When RSpec is running a suite, you can request a thread dump by sending
  a special signal to the process. This prints the backtrace of all threads
  to stderr, which helps debug hangs or deadlocks.

  On platforms that support it (e.g. macOS, BSD), RSpec listens for
  SIGINFO. You can send it in a terminal with Ctrl+T. On other platforms
  (e.g. Linux), RSpec uses SIGPWR if available. If neither signal is
  available (e.g. Windows), no handler is installed and this feature is
  not available.

  The dump format is one line per backtrace frame: "Thread TID-<thread id> <thread name> <file:line>".
  Threads without a backtrace show "<no backtrace available>".

  Scenario: Sending the backtrace signal during a run prints a thread dump to stderr
    Given a file named "spec/truth_spec.rb" with:
      """ruby
      RSpec.describe "truth" do
        it "is truthy" do
          backtrace_signal = RSpec::Core::Runner.send(:backtrace_signal)
          Process.kill(backtrace_signal, Process.pid) if backtrace_signal
          expect(true).to be_truthy
        end
      end
      """
    When I run `rspec spec/truth_spec.rb`
    Then the output should contain %R{Thread TID-[a-z0-9]+ <[^>]*> .+/spec/truth_spec\.rb:4:in '(Process\.kill|kill)'}
    And the output should contain "spec/truth_spec.rb"
