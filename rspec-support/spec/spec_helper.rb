# frozen_string_literal: true

require 'rspec/support/spec'
RSpec::Support::Spec::Coverage.setup

RSpec::Matchers.define_negated_matcher :avoid_raising_errors, :raise_error
RSpec::Matchers.define_negated_matcher :avoid_changing, :change
