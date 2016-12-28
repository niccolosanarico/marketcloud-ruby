require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Coupon do

	describe 'a GET for a valid coupon' do

		let(:coupon) { VCR.use_cassette('coupon') { Marketcloud::Coupon.find(105360) }}

		it 'should return 200' do
			expect(coupon.response.status).to eq 200
		end

		it 'answers to find with a valid coupon' do
		  expect(coupon.code).to eq "MINUTERIA5"
		end

	end
end
