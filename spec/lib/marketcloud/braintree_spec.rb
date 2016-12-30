require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Braintree do
	describe 'a POST for a new Braintree token with a customer ID' do
		let(:user_id) { 107227 }
		let(:token) { VCR.use_cassette('braintree_token_with_user') { Marketcloud::Braintree.get_token(user_id) }}

		it 'should return 200' do
			expect(token.response.status).to eq 200
		end

	end

	describe 'a POST for a new Braintree token with no user id' do
		let(:token) { VCR.use_cassette('braintree_token') { Marketcloud::Braintree.get_token() }}

		it 'should return 200' do
			expect(token.response.status).to eq 200
		end

	end
end
