# Contributing

RSpec is a community-driven project that has benefited from improvements from over *500* contributors.
We welcome contributions from *everyone*. While contributing, please follow the project [code of conduct](CODE_OF_CONDUCT.md), so that everyone can be included.

If you'd like to help make RSpec better, here are some ways you can contribute:

  - by running RSpec HEAD to help us catch bugs before new releases
  - by [reporting bugs you encounter](https://github.com/rspec/rspec/issues/new) with [report template](#report-template)
  - by [suggesting new features](https://github.com/rspec/rspec/issues/new)
  - by improving RSpec's Feature or API [documentation](https://rspec.info/documentation/)
  - by improving [RSpec's website](https://rspec.info/) ([source](https://github.com/rspec/rspec.github.io))
  - by taking part in [feature and issue discussions](https://github.com/rspec/rspec/issues)
  - by adding a failing test for reproducible [reported bugs](https://github.com/rspec/rspec/issues)
  - by reviewing [pull requests](https://github.com/rspec/rspec/pulls) and suggesting improvements
  - by [writing code](DEVELOPMENT.md) (no patch is too small! fix typos or bad whitespace)

If you need help getting started, check out the [DEVELOPMENT](DEVELOPMENT.md) file for steps that will get you up and running.

Thanks for helping us make RSpec better!

## `Small` issues

These issue are ones that we be believe are best suited for new contributors to
get started with. They represent a meaningful contribution to the project that
should not be too hard to pull off.

## Report template

Having a way to reproduce your issue will be very helpful for others to help confirm,
investigate and ultimately fix your issue. You can do this by providing an executable
test case. To make this process easier, we have prepared one basic
[bug report templates](REPORT_TEMPLATE.md) for you to use as a starting point.

## Maintenance branches

Maintenance branches are how we manage the different supported point releases
of RSpec. As such, while they might look like good candidates to merge into
main, please do not open pull requests to merge them.

## Working on multiple RSpec gems at the same time

RSpec is composed of multiple gems (`rspec-core`, `rspec-mocks`, etc). Sometimes you have
to work on a combination of them at the same time. When submitting your code for review,
we ask that you get a passing build (green CI). If you are working across the repositories,
please add a commit that temporarily pins your PR to the right branch of the other repository
you depend on. For example, if we wanted a change in `rspec-expectations` that relied on a
change for on `rspec-mocks`. We add a commit with the title:

>[WIP] Use rspec-mocks with "custom-failure-message" branch

And content:

```ruby
%w[rspec rspec-core rspec-expectations rspec-support].each do |lib|
  if lib == 'rspec'
    gem lib, git: "https://github.com/rspec/rspec"
  else
    gem lib, git: "https://github.com/rspec/rspec", glob: "#{lib}/#{lib}.gemspec"
  end
end
gem 'rspec-mocks', git: "https://github.com/my_user_name/rspec", branch: 'your-custom-branch', glob: "rspec-mocks/rspec-mocks.gemspec"
```

In general the process is:
1. Create PRs explaining what you are trying to achieve.
2. Pin the repositories to each other.
3. Check they pass (go green).
4. Await review if appropriate.
5. Remove the commit from step 2. We will merge ignoring the failure.
6. Remove the commit from the other, check it passes with the other commit now on `main`.
7. Merge the other.
8. We will trigger builds for the `main` branch of affected repositories to check if everything is in order.

Steps 5-8 should happen continuously (e.g. one after another but within a short timespan)
so that we don't leave a broken main around. It is important to triage that build process
and revert if necessary.