# frozen_string_literal: true

# Required until https://github.com/rubinius/rubinius/issues/2430 is resolved
ENV['RBXOPT'] = "#{ENV["RBXOPT"]} -Xcompiler.no_rbc"

Around "@unsupported-on-rbx" do |_scenario, block|
  block.call unless defined?(Rubinius)
end
