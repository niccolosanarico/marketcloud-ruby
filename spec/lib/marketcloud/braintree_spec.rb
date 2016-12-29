require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Braintree do

	describe 'a new Braintree token' do

		let(:token) { VCR.use_cassette('braintree_token') { Marketcloud::Braintree.get_token() }}

		it 'should return 200' do
			expect(token.response.status).to eq 200
		end

	end
end
