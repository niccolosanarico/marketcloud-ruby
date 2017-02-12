require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Promotion do
	let(:promotion_id) { 125439 }

	describe 'a GET for a valid promotion' do

		let(:promotion) { VCR.use_cassette('promotion') { Marketcloud::Promotion.find(promotion_id) }}

		it 'should return 200' do
			expect(promotion).not_to be_nil
		end

		it 'answers to find with a valid promotion' do
		  expect(promotion.name).to eq "Black Friday"
		end

		it 'should have conditions' do
			expect(promotion.conditions).not_to be_nil
		end

		it 'should have effects' do
			expect(promotion.effects).not_to be_nil
		end

	end
end
