RSpec.describe 'OrderGroup' do
  let(:order_group) { ::RSpec::Mocks::OrderGroup.new }

  describe '#consume' do
    let(:ordered_1) { double :ordered? => true }
    let(:ordered_2) { double :ordered? => true }
    let(:unordered) { double :ordered? => false }

    before do
      order_group.register unordered
      order_group.register ordered_1
      order_group.register unordered
      order_group.register ordered_2
      order_group.register unordered
      order_group.register unordered
    end

    it 'returns the first ordered? expectation' do
      expect(order_group.consume).to eq ordered_1
    end

    it 'keeps returning ordered? expectation until all are returned' do
      expectations = 3.times.map { order_group.consume }
      expect(expectations).to eq [ordered_1, ordered_2, nil]
    end
  end

  describe '#invoked' do
    let(:ordered) { double :ordered? => true }

    it 'handles concurrent registration of invocations' do
      concurrency = 4
      repetition = 10

      (concurrency * repetition).times do
        order_group.register ordered
      end

      concurrency.times.map do |_|
        Thread.new do
          repetition.times do |_|
            order_group.invoked ordered
          end
        end
      end.map(&:join)

      expect(order_group.send(:expected_invocations).size).to eq(concurrency * repetition)
    end
  end
end
