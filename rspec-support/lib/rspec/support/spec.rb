# frozen_string_literal: true

require 'rspec/support'
require 'rspec/support/spec/in_sub_process'

RSpec::Support.require_rspec_support "spec/coverage"
RSpec::Support.require_rspec_support "spec/deprecation_helpers"
RSpec::Support.require_rspec_support "spec/with_isolated_stderr"
RSpec::Support.require_rspec_support "spec/stderr_splitter"
RSpec::Support.require_rspec_support "spec/formatting_support"
RSpec::Support.require_rspec_support "spec/with_isolated_directory"
RSpec::Support.require_rspec_support "ruby_features"

warning_preventer = $stderr = RSpec::Support::StdErrSplitter.new($stderr)

RSpec.configure do |c|
  c.include RSpecHelpers
  c.include RSpec::Support::WithIsolatedStdErr
  c.include RSpec::Support::FormattingSupport
  c.include RSpec::Support::InSubProcess

  unless defined?(Debugger) # debugger causes warnings when used
    c.before do
      warning_preventer.reset!
    end

    c.after do
      warning_preventer.verify_no_warnings!
    end
  end

  if c.files_to_run.one?
    c.full_backtrace = true
    c.default_formatter = 'doc'
  end

  c.filter_run_when_matching :focus

  c.example_status_persistence_file_path = "./spec/examples.txt"

  c.define_derived_metadata :failing_on_windows_ci do |meta|
    meta[:pending] ||= "This spec fails on Windows CI and needs someone to fix it."
  end if RSpec::Support::OS.windows? && ENV['CI']
end
