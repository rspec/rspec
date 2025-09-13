# frozen_string_literal: true

require 'rspec/support/reentrant_mutex'
require 'thread_order'

# There are no assertions specifically
# They pass if they don't deadlock
RSpec.describe RSpec::Support::ReentrantMutex do
  let!(:mutex) { described_class.new }
  let!(:order) { ThreadOrder.new }
  after { order.apocalypse! }

  it 'can repeatedly synchronize within the same thread' do
    mutex.synchronize { mutex.synchronize { } }
  end

  it 'locks other threads out while in the synchronize block' do
    order.declare(:before) { mutex.synchronize { } }
    order.declare(:within) { mutex.synchronize { } }
    order.declare(:after)  { mutex.synchronize { } }

    order.pass_to :before, :resume_on => :exit
    mutex.synchronize { order.pass_to :within, :resume_on => :sleep }
    order.pass_to :after, :resume_on => :exit
  end

  it 'resumes the next thread once all its synchronize blocks have completed' do
    order.declare(:thread) { mutex.synchronize { } }
    mutex.synchronize { order.pass_to :thread, :resume_on => :sleep }
    order.join_all
  end

  # On Ruby 3.1.3+ the raise in this spec can
  # bypass the `raise_error` capture and break this spec but
  # it is not sufficient to pend it as the raise can escape to the other
  # threads somehow therefore poisoning them so its skipped entirely.
  # This is a temporary work around to allow green cross project builds but
  # needs a fix.
  if RUBY_VERSION >= '3.0' && RUBY_VERSION < '3.1.3'
    it 'waits when trying to lock from another Fiber' do
      mutex.synchronize do
        ready = false
        f = Fiber.new do
          expect {
            ready = true
            mutex.send(:enter)
            raise 'should reach here: mutex is already locked on different Fiber'
          }.to raise_error(Exception, 'waited correctly')
        end

        main_thread = Thread.current

        t = Thread.new do
          Thread.pass until ready && main_thread.stop?
          main_thread.raise Exception, 'waited correctly'
        end
        f.resume
        t.join
      end
    end
  end
end
