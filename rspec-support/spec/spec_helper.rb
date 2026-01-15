# frozen_string_literal: true

require 'rspec/support/spec'
# Preload io/console on MacOS JRuby to avoid warnings later due to https://github.com/jruby/jruby/issues/8271
require 'io/console' if RSpec::Support::Ruby.jruby? && RSpec::Support::OS.apple_silicon?

RSpec::Support::Spec::Coverage.setup

RSpec::Matchers.define_negated_matcher :avoid_raising_errors, :raise_error
RSpec::Matchers.define_negated_matcher :avoid_changing, :change
