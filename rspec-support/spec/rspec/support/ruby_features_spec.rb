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

        def ripper_works_correctly?
          ripper_reports_correct_line_number? &&
            ripper_can_parse_source_including_keywordish_symbol? &&
            ripper_can_parse_source_referencing_keyword_arguments?
        end

        # https://github.com/jruby/jruby/issues/3386
        def ripper_reports_correct_line_number?
          in_sub_process_if_possible do
            require 'ripper'
            tokens = ::Ripper.lex('foo')
            token = tokens.first
            location = token.first
            line_number = location.first
            line_number == 1
          end
        end

        # https://github.com/jruby/jruby/issues/4562
        def ripper_can_parse_source_including_keywordish_symbol?
          in_sub_process_if_possible do
            require 'ripper'
            sexp = ::Ripper.sexp(':if')
            !sexp.nil?
          end
        end

        # https://github.com/jruby/jruby/issues/5209
        def ripper_can_parse_source_referencing_keyword_arguments?
          in_sub_process_if_possible do
            require 'ripper'
            # It doesn't matter if keyword arguments don't exist.
            if Ruby.mri? || Ruby.jruby? || Ruby.truffleruby?
              begin
                !::Ripper.sexp('def a(**kw_args); end').nil?
              rescue NoMethodError
                false
              end
            end
          end
        end

        it 'returns whether Ripper is correctly implemented in the current environment' do
          expect(RubyFeatures.ripper_supported?).to eq(ripper_is_implemented? && ripper_works_correctly?)
        end

        it 'does not load Ripper' do
          expect { RubyFeatures.ripper_supported? }.not_to change { defined?(::Ripper) }
        end
      end
    end
  end
end
