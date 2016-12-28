require_relative '../spec_helper'

RSpec.describe Marketcloud do

  describe "#configure" do

    let(:products) { VCR.use_cassette('products_for_config') { Marketcloud::Product.all() }}

    it "can make public queries" do
      expect(products.first.response.status).to eq 200
    end
  end
end
