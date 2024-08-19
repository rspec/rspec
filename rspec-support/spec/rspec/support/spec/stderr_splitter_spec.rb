# frozen_string_literal: true

require 'rspec/support/spec/stderr_splitter'
require 'tempfile'
require 'rspec/support/spec/in_sub_process'

RSpec.describe 'RSpec::Support::StdErrSplitter' do
  include RSpec::Support::InSubProcess

  let(:splitter) { RSpec::Support::StdErrSplitter.new stderr }
  let(:stderr)   { STDERR }

  before do
    allow(stderr).to receive(:write)
  end

  around do |example|
    original = $stderr
    $stderr = splitter

    example.run

    $stderr = original
  end

  it 'conforms to the stderr interface' do
    # There some methods that appear in the list of the #methods but actually not implemented:
    #
    #     $stderr.pressed?
    #     NotImplementedError: pressed?() function is unimplemented on this machine
    stderr_methods = stderr.methods.select { |method| stderr.respond_to?(method) }

    # On 2.2, there's a weird issue where stderr sometimes responds to `birthtime` and sometimes doesn't...
    stderr_methods -= [:birthtime] if RUBY_VERSION =~ /^2\.2/

    # No idea why, but on our AppVeyor windows builds it doesn't respond to these...
    stderr_methods -= [:close_on_exec?, :close_on_exec=] if RSpec::Support::OS.windows? && ENV['CI']

    expect(splitter).to respond_to(*stderr_methods)
  end

  it 'acknowledges its own interface' do
    expect(splitter).to respond_to :==, :write, :has_output?, :reset!, :verify_no_warnings!, :output
  end

  it 'supports methods that stderr supports but StringIO does not' do
    expect(StringIO.new).not_to respond_to(:stat)
    expect(splitter.stat).to be_a(File::Stat)
  end

  it 'supports #to_io' do
    expect(splitter.to_io).to be(stderr.to_io)
  end

  it 'behaves like stderr' do
    splitter.write 'a warning'
    expect(stderr).to have_received(:write)
  end

  it 'pretends to be stderr' do
    expect(splitter).to eq stderr
  end

  it 'resets when reopened' do
    in_sub_process(false) do
      warn 'a warning'
      allow(stderr).to receive(:write).and_call_original

      Tempfile.open('stderr') do |file|
        splitter.reopen(file)
        expect { splitter.verify_no_warnings! }.not_to raise_error
      end
    end
  end

  it 'tracks when output to' do
    splitter.write 'a warning'
    expect(splitter).to have_output
  end

  it 'will ignore examples without a warning' do
    splitter.verify_no_warnings!
  end

  it 'will ignore examples after a reset a warning' do
    warn 'a warning'
    splitter.reset!
    splitter.verify_no_warnings!
  end

  unless RSpec::Support::Ruby.rbx? || RSpec::Support::Ruby.truffleruby?
    # TruffleRuby doesn't support warnings for now
    # https://github.com/oracle/truffleruby/issues/2595
    # rubocop:disable Lint/Void
    it 'will fail an example which generates a warning' do
      true unless $undefined
      expect { splitter.verify_no_warnings! }.to raise_error(/Warnings were generated:/)
    end
    # rubocop:enable Lint/Void
  end

  it 'does not reuse the stream when cloned' do
    expect(splitter.to_io).not_to eq(splitter.clone.to_io)
  end

  # This spec replicates what matchers do when capturing stderr, e.g `to_stderr_from_any_process`
  it 'is able to restore the stream from a cloned StdErrSplitter' do
    cloned = splitter.clone
    expect(splitter.to_io).to be_stderr

    tempfile = Tempfile.new("foo")
    begin
      splitter.reopen(tempfile)
      expect(splitter.to_io).to_not be_stderr
    ensure
      splitter.reopen(cloned)
      tempfile.close
      tempfile.unlink
    end
    # This is the important part of the test that would fail without proper cloning hygeine
    expect(splitter.to_io).to be_stderr
  end

  # Detecting STDERR in a way that doesn't use a reference
  if STDERR.respond_to?(:path)
    def be_stderr
      have_attributes({:path => '<STDERR>'})
    end
  elsif STDERR.inspect =~ /STDERR/
    def be_stderr
      have_attributes({:inspect => "#<IO:<STDERR>>"})
    end
  else
    def be_stderr
      raise skip "JRuby < 9.0.0.0 doesn't have a predictable identifier for stdout"
    end
  end
end
