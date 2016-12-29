require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Coupon do
	let(:coupon_id) { 107241 }

	describe 'a GET for a valid coupon' do

		let(:coupon) { VCR.use_cassette('coupon') { Marketcloud::Coupon.find(coupon_id) }}

		it 'should return 200' do
			expect(coupon.response.status).to eq 200
		end

		it 'answers to find with a valid coupon' do
		  expect(coupon.code).to eq "MINUTERIA5"
		end

	end
end
