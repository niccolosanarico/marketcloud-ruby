require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Payment do
	let(:order_id) { 107236 }

	describe 'a POST for a new Braintree nonce' do

		let(:payment) { VCR.use_cassette('payment') { Marketcloud::Payment.create(order_id, "fake-valid-nonce") }}

		it 'should return 200' do
			expect(payment.response.status).to eq 200
		end

	end
end
