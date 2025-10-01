# frozen_string_literal: true

require 'stringio'

module RSpec
  module Support
    class StdErrSplitter
      def initialize(original)
        @orig_stderr    = original
        @output_tracker = ::StringIO.new
        @last_line = nil
      end

      def respond_to_missing?(*args)
        @orig_stderr.respond_to?(*args) || super
      end

      def method_missing(name, *args, &block)
        @output_tracker.__send__(name, *args, &block) if @output_tracker.respond_to?(name)
        @orig_stderr.__send__(name, *args, &block)
      end

      def clone
        StdErrSplitter.new(@orig_stderr.clone)
      end

      def ==(other)
        @orig_stderr == other
      end

      def reopen(*args)
        reset!
        @orig_stderr.reopen(*args)
      end

      def write(line)
        # Ignore warnings coming from gems, specifically Rails
        return if line =~ %r{^\S+/gems/\S+:\d+: warning:} # http://rubular.com/r/kqeUIZOfPG

        @orig_stderr.write(line)
        @output_tracker.write(line)
      ensure
        @last_line = line
      end

      def has_output?
        !output.empty?
      end

      def reset!
        @output_tracker = ::StringIO.new
      end

      def verify_no_warnings!
        raise "Warnings were generated: #{output}" if has_output?
        reset!
      end

      def output
        @output_tracker.string
      end
    end
  end
end
