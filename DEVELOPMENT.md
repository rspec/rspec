# Development Setup

Generally speaking, you only need to clone the project and install
the dependencies with [Bundler](https://bundler.io/). 

Clone the repo:

```
$ git clone git@github.com:rspec/rspec.git
```

Install the dependencies using [Bundler](https://bundler.io/):

```
$ cd rspec
$ bundle install
```

## Working on an individual library

Each rspec-* library is a standalone gem, with a standalone build. We recommend you
treat each as such and run development tools from their individual directories.

For convience though, you can also run `script/run_rspec` from the root directory
to run all the specs, as well as `bin/rubocop` to check all files for recommendations
at once.

# Bundler setup

To minimize boot time and to ensure we don't depend upon any extra dependencies
loaded by Bundler, our CI builds avoid loading Bundler at runtime
by using Bundler's [`--standalone option`](https://myronmars.to/n/dev-blog/2012/03/faster-test-boot-times-with-bundler-standalone).

While not strictly necessary (many/most of our contributors do not do this!),
if you want to exactly reproduce our CI builds you'll want to do the same:

```
$ rm Gemfile.lock
$ bundle install --standalone --path <current_lib>/bundle
$ bundle binstubs --path <current_lib>/bundle/bin
```

The `binstubs` option creates the `bin/rspec` file that, like `bundle exec rspec`, will load
all the versions specified in `Gemfile.lock` without loading bundler at runtime!

Note that as a set of gems we don't check in `Gemfile.lock`, so to replicate a CI build on branch
changes / after a period of time you will need to delete your local `Gemfile.lock` file to install
the same gems as CI.

## Extra Gems

If you need additional gems for any tasks---such as `benchmark-ips` for benchmarking
or `byebug` for debugging---you can create a `Gemfile-custom` file containing those
gem declarations. The `Gemfile` evaluates that file if it exists, and it is git-ignored.

# Running the build

The [CI build](https://github.com/rspec/rspec/actions)
runs many verification steps to prevent regressions and
ensure high-quality code. To run the build locally, for an individual library run:

```
$ ../script/run_rspec
$ ../script/run_rspec_one_by_one
$ ../script/run_cucumber
```

See [build detail](BUILD_DETAIL.md) for more detail.

# What to Expect

To ensure high, uniform code quality, all code changes (including
changes from the maintainers!) are subject to a pull request code
review. We'll often ask for clarification or suggest alternate ways
to do things. Our code reviews are intended to be a two-way
conversation.

Here's a short, non-exhaustive checklist of things we typically ask contributors to do before PRs are ready to merge. It can help get your PR merged faster if you do these in advance!

- [ ] New behavior is covered by tests and all tests are passing.
- [ ] No Ruby warnings are issued by your changes.
- [ ] Documentation reflects changes and renders as intended.
- [ ] RuboCop passes (e.g. `bundle exec rubocop lib`).
- [ ] Commits are squashed into a reasonable number of logical changesets that tell an easy-to-follow story.
- [ ] No changelog entry is necessary (we'll add it as part of the merge process!)

# Adding Docs

RSpec uses [YARD](https://yardoc.org/) for its API documentation. To
ensure the docs render well, we recommend running a YARD server and
viewing your edits in a browser.

To run a YARD server:

```
$ bundle exec yard server --reload

# or, if you installed your bundle with `--standalone --binstubs`:

$ bin/yard server --reload
```

Then navigate to `localhost:8808` to view the rendered docs.
