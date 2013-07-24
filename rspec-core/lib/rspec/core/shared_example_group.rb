module RSpec
  module Core
    module SharedExampleGroup
      # @overload shared_examples(name, &block)
      # @overload shared_examples(name, tags, &block)
      #
      # Wraps the `block` in a module which can then be included in example
      # groups using `include_examples`, `include_context`, or
      # `it_behaves_like`.
      #
      # @param [String] name to match when looking up this shared group
      # @param block to be eval'd in a nested example group generated by `it_behaves_like`
      #
      # @example
      #
      #   shared_examples "auditable" do
      #     it "stores an audit record on save!" do
      #       lambda { auditable.save! }.should change(Audit, :count).by(1)
      #     end
      #   end
      #
      #   class Account do
      #     it_behaves_like "auditable" do
      #       def auditable; Account.new; end
      #     end
      #   end
      #
      # @see ExampleGroup.it_behaves_like
      # @see ExampleGroup.include_examples
      # @see ExampleGroup.include_context
      def shared_examples(*args, &block)
        SharedExampleGroup.registry.add_group(self, *args, &block)
      end

      alias_method :shared_context,      :shared_examples
      alias_method :share_examples_for,  :shared_examples
      alias_method :shared_examples_for, :shared_examples

      def shared_example_groups
        SharedExampleGroup.registry.shared_example_groups_for('main', *ancestors[0..-1])
      end

      module TopLevelDSL
        def shared_examples(*args, &block)
          SharedExampleGroup.registry.add_group('main', *args, &block)
        end

        alias_method :shared_context,      :shared_examples
        alias_method :share_examples_for,  :shared_examples
        alias_method :shared_examples_for, :shared_examples

        def shared_example_groups
          SharedExampleGroup.registry.shared_example_groups_for('main')
        end
      end

      def self.registry
        @registry ||= Registry.new
      end

      # @private
      #
      # Used internally to manage the shared example groups and
      # constants. We want to limit the number of methods we add
      # to objects we don't own (main and Module) so this allows
      # us to have helper methods that don't get added to those
      # objects.
      class Registry
        def add_group(source, *args, &block)
          ensure_block_has_source_location(block, caller[1])

          if key? args.first
            key = args.shift
            warn_if_key_taken source, key, block
            add_shared_example_group source, key, block
          end

          unless args.empty?
            mod = Module.new
            (class << mod; self; end).send :define_method, :extended  do |host|
              host.class_eval(&block)
            end
            RSpec.configuration.extend mod, *args
          end
        end

        def shared_example_groups_for(*sources)
          Collection.new(sources, shared_example_groups)
        end

        def shared_example_groups
          @shared_example_groups ||= Hash.new { |hash,key| hash[key] = Hash.new }
        end

        def clear
          shared_example_groups.clear
        end

      private

        def add_shared_example_group(source, key, block)
          shared_example_groups[source][key] = block
        end

        def key?(candidate)
          [String, Symbol, Module].any? { |cls| cls === candidate }
        end

        def warn_if_key_taken(source, key, new_block)
          return unless existing_block = example_block_for(source, key)

          Kernel.warn <<-WARNING.gsub(/^ +\|/, '')
            |WARNING: Shared example group '#{key}' has been previously defined at:
            |  #{formatted_location existing_block}
            |...and you are now defining it at:
            |  #{formatted_location new_block}
            |The new definition will overwrite the original one.
          WARNING
        end

        def formatted_location(block)
          block.source_location.join ":"
        end

        def example_block_for(source, key)
          shared_example_groups[source][key]
        end

        def ensure_block_has_source_location(block, caller_line)
          return if block.respond_to?(:source_location)

          block.extend Module.new {
            define_method :source_location do
              caller_line.split(':')
            end
          }
        end
      end
    end
  end
end

extend RSpec::Core::SharedExampleGroup::TopLevelDSL
Module.send(:include, RSpec::Core::SharedExampleGroup)

