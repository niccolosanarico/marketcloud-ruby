require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::PaymentMethod do
	let(:pm_id) { 121182 }

	describe 'a GET on a valid payment method' do
		let(:pm) { VCR.use_cassette('pm_ok') { Marketcloud::PaymentMethod.find(pm_id) }}

		it 'should return 200' do
			expect(pm).not_to be_nil
		end

		it 'answers to find with a valid payment method' do
		  expect(pm.name).to eq "Bonifico bancario"
		end
	end

	describe 'a GET on an invalid url for a payment method' do
		let(:pm) { VCR.use_cassette('pm_ko') { Marketcloud::PaymentMethod.find(-1) }}

		it 'should return nil' do
			expect(pm).to be_nil
		end
	end

	describe 'a GET on an invalid payment method' do
		let(:pm) { VCR.use_cassette('pm_no') { Marketcloud::PaymentMethod.find(1) }}

		it 'should return nil' do
			expect(pm).to be_nil
		end
	end

	describe 'a GET for a paginated list of payment methods' do
		let(:pms) { VCR.use_cassette('pm_list') { Marketcloud::PaymentMethod.all() }}

		it 'should return an array' do
			expect(pms).to be_kind_of(Array)
		end

		it 'should contain a list of elements' do
			expect(pms.length).to be >= 0
		end
	end
end
