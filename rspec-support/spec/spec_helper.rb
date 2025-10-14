require 'rspec/support/spec'
RSpec::Support::Spec.setup_simplecov

RSpec::Matchers.define_negated_matcher :avoid_raising_errors, :raise_error
RSpec::Matchers.define_negated_matcher :avoid_changing, :change

RSpec.configure do |c|
  c.suppress_deprecations do
    c.disable_monkey_patching!
  end

  c.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
