# frozen_string_literal: true

require 'rspec/support/hunk_generator'

module RSpec
  module Support
    RSpec.describe HunkGenerator do
      describe '#hunks' do
        it 'splits each string into lines once, however many hunks it builds' do
          expected = (1..20).to_a.join("\n")
          actual   = expected.sub("\n2\n", "\nchanged\n").sub("\n18\n", "\nchanged\n")
          allow(expected).to receive(:split).and_call_original
          allow(actual).to receive(:split).and_call_original

          expect(HunkGenerator.new(actual, expected).hunks.size).to eq(2)
          expect(expected).to have_received(:split).once
          expect(actual).to have_received(:split).once
        end
      end
    end
  end
end
