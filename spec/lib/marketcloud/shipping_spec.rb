require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Shipping do
	let(:ship_id) { 106867 }
	let(:ship_name) { "SDA" }

	describe 'a GET on a valid shipping method' do
	  let(:shipping) { VCR.use_cassette('shipping') { Marketcloud::Shipping.find(ship_id) }}

		it 'should return 200' do
			expect(shipping.response.status).to eq 200
		end

		it 'answers to find with a valid shipping' do
		  expect(shipping.name).to eq ship_name
		end

	end

	describe 'a GET on all shipping methods' do
		let(:shippings) { VCR.use_cassette('shippings') { Marketcloud::Shipping.all }}

		it 'answers with an array' do
		  expect(shippings).to be_kind_of(Array)
		end

		it 'returns 200' do
			expect(shippings.first.response.status).to eq 200
		end
	end

end
