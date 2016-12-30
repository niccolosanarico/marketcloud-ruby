require_relative '../spec_helper'

RSpec.describe Marketcloud do

  describe "#configure" do

    let(:products) { VCR.use_cassette('products_for_config') { Marketcloud::Product.all() }}

    it "can make public queries" do
      expect(products).not_to be_nil
    end
  end
end
