require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Payment do
	let(:order_id) { 107236 }

	describe 'a POST for a new Braintree nonce' do

		# let(:payment) { VCR.use_cassette('payment') { Marketcloud::Payment.create(order_id, token.token) }}

		it 'should return 200' do
			pending "How to test braintree nonce?"
		end

	end
end
