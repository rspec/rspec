# frozen_string_literal: true

require 'rspec/support/spec/library_wide_checks'

RSpec.describe "RSpec::Expectations" do
  allowed_loaded_features = [
    /stringio/, # Used by `output` matcher. Can't be easily avoided.
    /rbconfig/  # required by rspec-support
  ]

  # Truffleruby cext files
  allowed_loaded_features << /\/truffle\/cext/ if RSpec::Support::Ruby.truffleruby?

  it_behaves_like "library wide checks", "rspec-expectations",
    :preamble_for_lib => [
      # We define minitest constants because rspec/expectations/minitest_integration
      # expects these constants to already be defined.
      "module Minitest; class Assertion; end; module Test; end; end",
      'require "rspec/expectations"'
    ],
    :allowed_loaded_feature_regexps => allowed_loaded_features

  it 'does not allow expectation failures to be caught by a bare rescue' do
    expect {
      expect(2).to eq(3) rescue nil
    }.to fail_including("expected: 3")
  end
end
