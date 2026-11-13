require 'aruba/cucumber'
require 'rspec/expectations'

Aruba.configure do |config|
  if RUBY_PLATFORM =~ /java/ || defined?(Rubinius) || (defined?(RUBY_ENGINE) && RUBY_ENGINE == 'truffleruby')
    config.exit_timeout = 60
  else
    config.exit_timeout = 5
  end
end

Before do
  if RUBY_PLATFORM == 'java'
    # disable JIT since these processes are so short lived
    set_environment_variable('JRUBY_OPTS', "-X-C #{ENV['JRUBY_OPTS']}")
  end

  if defined?(Rubinius)
    # disable JIT since these processes are so short lived
    set_environment_variable('RBXOPT', "-Xint=true #{ENV['RBXOPT']}")
  end
end

Before('@skip-when-no-parser-or-jruby') do |scenario|
  if RSpec::Support::Ruby.jruby? || !RSpec::Support::RubyFeatures.parser_supported?
    if RSpec::Support::Ruby.jruby?
      warn "Skipping scenario due to lack of support by JRuby"
    else
      warn "Skipping scenario due to lack of parser support"
    end

    if Cucumber::VERSION.to_f >= 3.0
      skip_this_scenario
    else
      scenario.skip_invoke!
    end
  end
end
