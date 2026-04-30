# frozen_string_literal: true

require 'rspec/support/ruby_features'

module RSpec
  module Support
    RSpec.describe OS do

      describe ".windows?" do
        %w[cygwin mswin mingw bccwin wince emx].each do |fragment|
          it "returns true when host os is #{fragment}" do
            stub_const("RbConfig::CONFIG", 'host_os' => fragment)
            expect(OS.windows?).to be true
          end
        end

        %w[darwin linux].each do |fragment|
          it "returns false when host os is #{fragment}" do
            stub_const("RbConfig::CONFIG", 'host_os' => fragment)
            expect(OS.windows?).to be false
          end
        end
      end

      describe ".windows_file_path?" do
        it "returns true when the file alt separator is a colon" do
          stub_const("File::ALT_SEPARATOR", "\\") unless OS.windows?
          expect(OS).to be_windows_file_path
        end

        it "returns false when file alt separator is not present" do
          stub_const("File::ALT_SEPARATOR", nil) if OS.windows?
          expect(OS).to_not be_windows_file_path
        end
      end

      describe ".macos?" do
        %w[darwin Darwin].each do |fragment|
          it "returns true when host os is #{fragment}" do
            stub_const("RbConfig::CONFIG", 'host_os' => fragment)
            expect(OS.macos?).to be true
          end
        end

        %w[cygwin mswin mingw bccwin wince emx linux].each do |fragment|
          it "returns false when host os is #{fragment}" do
            stub_const("RbConfig::CONFIG", 'host_os' => fragment)
            expect(OS.macos?).to be false
          end
        end
      end

      describe ".apple_silicon?" do
        %w[arm64 aarch64].each do |fragment|
          it "returns true when host cpu is #{fragment}" do
            stub_const("RbConfig::CONFIG", 'host_os' => 'darwin', 'host_cpu' => fragment)
            expect(OS.apple_silicon?).to be true
          end
        end

        %w[i386 x86 x86_64 amd64].each do |fragment|
          it "returns false when host cpu is #{fragment}" do
            stub_const("RbConfig::CONFIG", 'host_os' => 'darwin', 'host_cpu' => fragment)
            expect(OS.apple_silicon?).to be false
          end
        end

        it "returns false when host os is not darwin" do
          stub_const("RbConfig::CONFIG", 'host_os' => 'linux', 'host_cpu' => 'arm64')
          expect(OS.apple_silicon?).to be false
        end
      end
    end

    RSpec.describe Ruby do
      specify "jruby? reflects the state of RUBY_PLATFORM" do
        stub_const("RUBY_PLATFORM", "java")
        expect(Ruby).to be_jruby
        stub_const("RUBY_PLATFORM", "")
        expect(Ruby).to_not be_jruby
      end

      specify "rbx? reflects the state of RUBY_ENGINE" do
        stub_const("RUBY_ENGINE", "rbx")
        expect(Ruby).to be_rbx
        hide_const("RUBY_ENGINE")
        expect(Ruby).to_not be_rbx
      end

      specify "rbx? reflects the state of RUBY_ENGINE" do
        hide_const("RUBY_ENGINE")
        expect(Ruby).to be_mri
        stub_const("RUBY_ENGINE", "ruby")
        expect(Ruby).to be_mri
        stub_const("RUBY_ENGINE", "rbx")
        expect(Ruby).to_not be_mri
      end
    end

    RSpec.describe RubyFeatures do
      specify "#fork_supported? exists" do
        RubyFeatures.fork_supported?
      end

      specify "#supports_syntax_suggest?" do
        expect(RubyFeatures.supports_syntax_suggest?).to eq(RUBY_VERSION.to_f >= 3.2)
      end

      describe "#ripper_supported?" do
        def ripper_is_implemented?
          in_sub_process_if_possible do
            begin
              require 'ripper'
              !!defined?(::Ripper) && Ripper.respond_to?(:lex)
            rescue LoadError
              false
            end
          end
        end

        it 'returns whether Ripper is correctly implemented in the current environment' do
          expect(RubyFeatures.ripper_supported?).to eq(ripper_is_implemented?)
        end

        it 'does not load Ripper' do
          expect { RubyFeatures.ripper_supported? }.not_to change { defined?(::Ripper) }
        end
      end
    end
  end
end
