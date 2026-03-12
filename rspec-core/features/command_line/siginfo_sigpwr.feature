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
    Given a file named "slow_spec.rb" with:
      """ruby
      RSpec.describe "slow examples" do
        it "sleeps a bit" do
          sleep 2
        end
        it "sleeps again" do
          sleep 1
        end
      end
      """
    When I run `rspec slow_spec.rb` with the backtrace signal sent during the run
    Then the output should contain %R{Thread TID-[a-z0-9]+ <[^>]+> .+/slow_spec.rb:}
    And the output should contain "slow_spec.rb"
