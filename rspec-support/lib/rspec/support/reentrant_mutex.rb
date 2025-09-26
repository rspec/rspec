# frozen_string_literal: true

module RSpec
  module Support
    # This class protects us against Mutex.new stubbed out within tests.
    # @private
    class Mutex < ::Mutex
      class << self
        define_method(:new, &::Mutex.method(:new))
      end
    end

    # Allows a thread to lock out other threads from a critical section of code,
    # while allowing the thread with the lock to reenter that section.
    #
    # Based on Monitor as of 2.2 -
    # https://github.com/ruby/ruby/blob/eb7ddaa3a47bf48045d26c72eb0f263a53524ebc/lib/monitor.rb#L9
    #
    # @private
    class ReentrantMutex
      def initialize
        @owner = nil
        @count = 0
        @mutex = Mutex.new
      end

      def synchronize
        enter
        yield
      ensure
        exit
      end

    private

      def enter
        @mutex.lock unless @mutex.owned?
        @count += 1
      end

      def exit
        unless @mutex.owned?
          raise ThreadError, "Attempt to unlock a mutex which is locked by another thread/fiber"
        end
        @count -= 1
        @mutex.unlock if @count == 0
      end
    end
  end
end
