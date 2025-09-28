if defined?(Cucumber)
  require 'shellwords'
  use_tilde_tags = !defined?(::RUBY_ENGINE_VERSION) || (::RUBY_ENGINE_VERSION < '2.0.0')
  exclude_with_clean_spec_ops = use_tilde_tags ? '~@with-clean-spec-opts' : 'not @with-clean-spec-opts'
  Before(exclude_with_clean_spec_ops) do
    set_environment_variable('SPEC_OPTS', "-r#{Shellwords.escape(__FILE__)}")
  end

  Before('@oneliner-should') do
    set_environment_variable('ALLOW_ONELINER_SHOULD', 'true')
  end
else
  if ENV['REMOVE_OTHER_RSPEC_LIBS_FROM_LOAD_PATH']
    $LOAD_PATH.reject! { |x| /rspec-mocks/ === x || /rspec-expectations/ === x }
  end

  module DisallowOneLinerShould
    def should(*)
      raise "one-liner should is not allowed"
    end

    def should_not(*)
      raise "one-liner should_not is not allowed"
    end
  end

  RSpec.configure do |rspec|
    rspec.disable_monkey_patching!
    rspec.include DisallowOneLinerShould unless ENV['ALLOW_ONELINER_SHOULD']
  end
end
