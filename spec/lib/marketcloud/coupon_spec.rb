require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Coupon do
	let(:coupon_id) { 155682 }

	describe 'a GET for a valid coupon' do

		let(:coupon) { VCR.use_cassette('coupon') { Marketcloud::Coupon.find(coupon_id) }}

		it 'should return 200' do
			expect(coupon).not_to be_nil
		end

		it 'answers to find with a valid coupon' do
		  expect(coupon.code).to eq "FORNI5"
		end

	end

  describe 'a GET on coupon by code' do
    let(:coup) { VCR.use_cassette('coupon_by_code') { Marketcloud::Coupon.find_by_code("FORNI5") }}

    it 'answers to find with the right coupon' do
		  expect(coup.code).to eq "FORNI5"
		end

    it 'returns 200' do
      expect(coup).not_to be_nil
    end
  end
end
