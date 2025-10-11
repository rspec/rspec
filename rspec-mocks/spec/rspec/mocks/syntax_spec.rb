module RSpec
  RSpec.describe Mocks do
    it "does not inadvertently define BasicObject on 1.8", :skip => RUBY_VERSION.to_f > 1.8 do
      expect(defined?(::BasicObject)).to be nil
    end
  end
end
