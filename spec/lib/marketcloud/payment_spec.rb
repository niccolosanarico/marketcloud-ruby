require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Payment do
	let(:order_id) { 107236 }
  let(:order_id_bad) { 108355 }

	describe 'a POST for a new Braintree nonce' do

		let(:payment) { VCR.use_cassette('payment_ok') { Marketcloud::Payment.create(order_id, "fake-valid-nonce") }}

		it 'should return true' do
			expect(payment.status).to be true
		end

	end

	describe 'a POST for an order with an invalid nonce should return false' do
		let(:payment) { VCR.use_cassette('payment_ko') { Marketcloud::Payment.create(order_id_bad, "fake-processor-declined-visa-nonce") }}

		it 'should return true' do
			expect(payment.status).to be false
		end
	end
end
