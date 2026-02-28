# frozen_string_literal: true
require "bundler"
Bundler.setup

GEMS = %i[rspec rspec-core rspec-mocks rspec-expectations rspec-support]

desc "Release all rspec gems"
task :release_all do
  helpers = {}

  GEMS.each do |name|
    helpers[name] = Bundler::GemHelper.new(name.to_s)
  end

  helpers[:rspec].send(:guard_clean)

  build_paths = {}

  # Build!
  helpers.each do |name, helper|
    build_paths[name] = helper.build_gem
  end

  # Push tags
  unless helpers[:rspec].send(:already_tagged?)
    helpers[:rspec].send(:tag_version) do
      helpers[:rspec].send(:git_push)
    end
  end

  # Release!
  helpers.each do |name, helper|
    helper.send(:rubygem_push, build_paths[name]) if helper.send(:gem_push?)
  end
end
