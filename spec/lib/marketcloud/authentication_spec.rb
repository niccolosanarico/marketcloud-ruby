require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Authentication do

	describe 'a valid auth token' do

		let(:token) { VCR.use_cassette('auth_token') { Marketcloud::Authentication.get_token() }}

		it 'should return 200' do
			expect(token).not_to be_nil
		end

	end
end
