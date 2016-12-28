require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Authentication do

	describe 'a valid auth token' do

		let(:token) { VCR.use_cassette('auth_token') { Marketcloud::Authentication.get_token() }}

		it 'should return 200' do
			expect(token.response.status).to eq 200
		end

	end
end
