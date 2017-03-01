require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Brand do
	let(:brand_id) { 114239 }

	describe 'a GET on a valid brand' do
		let(:brand) { VCR.use_cassette('brand_ok') { Marketcloud::Brand.find(brand_id) }}

		it 'should return 200' do
			expect(brand).not_to be_nil
		end

		it 'answers to find with a valid brand' do
		  expect(brand.name).to eq "Saturnia"
		end
	end

	describe 'a GET on an invalid url for a brand' do
		let(:brand) { VCR.use_cassette('brand_ko') { Marketcloud::Brand.find(-1) }}

		it 'should return nil' do
			expect(brand).to be_nil
		end
	end

	describe 'a GET on an invalid brand' do
		let(:brand) { VCR.use_cassette('brand_no') { Marketcloud::Brand.find(1) }}

		it 'should return nil' do
			expect(brand).to be_nil
		end
	end

	describe 'a GET for a paginated list of brands' do
		let(:brands) { VCR.use_cassette('brand_list_paginated') { Marketcloud::Brand.all() }}

		it 'should return an array' do
			expect(brands).to be_kind_of(Array)
		end

		it 'should contain a list of elements' do
			expect(brands.length).to be >= 0
		end
	end

	describe 'a POST to create a new brand' do
		let(:new_brand) { {name: 'a brand', description: 'With a name' } }
		let(:created_brand) { VCR.use_cassette('brand_new') { Marketcloud::Brand.create(new_brand) }}

		it 'is successfull' do
			expect(created_brand).not_to be_nil
		end

		it 'creates a new brand' do
			expect(created_brand.name).to eq new_brand[:name]
		end
	end
end
