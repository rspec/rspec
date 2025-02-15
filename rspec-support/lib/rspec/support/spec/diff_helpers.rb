# frozen_string_literal: true

require 'diff/lcs'

module RSpec
  module Support
    module Spec
      module DiffHelpers
        # diff-lcs 1.4.4+ is required, simplify version handling
        if ::Diff::LCS::VERSION.to_f < 1.6
          def one_line_header(line_number=2)
            if line_number <= 2
              "-1 +1"
            else
              "-1,#{line_number - 1} +1,#{line_number - 1}"
            end
          end
        else
          def one_line_header(_=2)
            "-1 +1"
          end
        end

        if ::Diff::LCS::VERSION.to_f > 1.5
          def removing_two_line_header
            "-1,2 +0,0"
          end
        else
          # diff-lcs 1.4.4 to 1.5.x
          def removing_two_line_header
            "-1,3 +1"
          end
        end
      end
    end
  end
end
