# rspec [![Build Status](https://github.com/rspec/rspec/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/rspec/rspec/actions) [![Code Climate](https://codeclimate.com/github/rspec/rspec.svg)](https://codeclimate.com/github/rspec/rspec)

This is the RSpec mono repo, it contains the core gems we think of as "rspec", they are:

* `rspec-core` provides the structure for writing executable examples of how your
  code should behave, and an `rspec` command with tools to constrain which
  examples get run and tailor the output.

* `rspec-expectations` lets you express expected outcomes on an object in an example.

* `rspec-mocks` is a test-double framework for rspec with support for method stubs,
  fakes, and message expectations on generated test-doubles and real objects
  alike.

* `rspec-support` provides shared helper functionality for the other three gems, in
  general you don't install this on its own.

## Install

    gem install rspec              # for rspec-core, rspec-expectations and rspec-mocks
    gem install rspec-core         # for rspec-core only
    gem install rspec-expectations # for rspec-expectations only
    gem install rspec-mocks        # for rspec-mocks only

Want to run against the `main` branch? You'll need to include the dependent
RSpec repos as well. Add the following to your `Gemfile`:

```ruby
%w[rspec rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
  if lib == 'rspec'
    gem lib, git: "https://github.com/rspec/rspec"
  else
    gem lib, git: "https://github.com/rspec/rspec", glob: "#{lib}/#{lib}.gemspec"
  end
end
```

## The `rspec` Command

If you install the rspec-core gem, it installs the `rspec` executable,
which you'll use to run rspec. The `rspec` command comes with many useful
options.

Run `rspec --help` to see the complete list.

## Getting started:

RSpec uses the words "describe" and "it" so we can express concepts like a conversation:

    "Describe a calculator."
    "It adds together numbers."

e.g.

```ruby
# in spec/calculator_spec.rb
RSpec.describe Calculator do
  describe '#add' do
    it 'returns the sum of its arguments' do
      expect(Calculator.new.add(1, 2)).to eq(3)
    end
  end
end
```

Run this with the rspec command, and watch it fail:

```
$ rspec spec/calculator_spec.rb
./spec/calculator_spec.rb:1: uninitialized constant Calculator
```

Address the failure by defining a skeleton of the `Calculator` class:

```ruby
# in lib/calculator.rb
class Calculator
  def add(a, b)
  end
end
```

Be sure to require the implementation file in the spec:

```ruby
# in spec/calculator_spec.rb
# - RSpec adds ./lib to the $LOAD_PATH
require "calculator"
```

Now run the spec again, and watch the expectation fail:

```
$ rspec spec/calculator_spec.rb
F

Failures:

  1) Calculator#add returns the sum of its arguments
     Failure/Error: expect(Calculator.new.add(1, 2)).to eq(3)

       expected: 3
            got: nil

       (compared using ==)
     # ./spec/calculator_spec.rb:6:in `block (3 levels) in <top (required)>'

Finished in 0.00131 seconds (files took 0.10968 seconds to load)
1 example, 1 failure

Failed examples:

rspec ./spec/calculator_spec.rb:5 # Calculator#add returns the sum of its arguments
```

Implement the simplest solution, by changing the definition of `Calculator#add` to:

```ruby
def add(a, b)
  a + b
end
```

Now run the spec again, and watch it pass:

```
$ rspec spec/calculator_spec.rb
.

Finished in 0.000315 seconds
1 example, 0 failures
```

Use the `documentation` formatter to see the resulting spec:

```
$ rspec spec/calculator_spec.rb --format doc
Calculator
  #add
    returns the sum of its arguments

Finished in 0.000379 seconds
1 example, 0 failures
```

## Contributing

Once you've set up the environment, you'll need to cd into the working
directory of whichever repo you want to work in. From there you can run the
specs and cucumber features, and make patches.

* [Build details](BUILD_DETAIL.md)
* [Code of Conduct](CODE_OF_CONDUCT.md)
* [Detailed contributing guide](CONTRIBUTING.md)
* [Development setup guide](DEVELOPMENT.md)

## Also see

* [https://github.com/rspec/rspec-rails](https://github.com/rspec/rspec-rails)
