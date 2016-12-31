require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Category do
	let(:cat_id) { 107225 }

	describe 'a GET on a valid category' do
		let(:category) { VCR.use_cassette('category_ok') { Marketcloud::Category.find(cat_id) }}

		it 'should return 200' do
			expect(category).not_to be_nil
		end

		it 'answers to find with a valid category' do
		  expect(category.name).to eq "Minuteria"
		end
	end

	describe 'a GET on an invalid url for a category' do
		let(:category) { VCR.use_cassette('category_ko') { Marketcloud::Category.find(-1) }}

		it 'should return nil' do
			expect(category).to be_nil
		end
	end

	describe 'a GET on an invalid category' do
		let(:category) { VCR.use_cassette('category_no') { Marketcloud::Category.find(1) }}

		it 'should return nil' do
			expect(category).to be_nil
		end
	end

	describe 'a GET for a paginated list of categories' do
		let(:categories) { VCR.use_cassette('category_list_paginated') { Marketcloud::Category.all() }}

		it 'should return an array' do
			expect(categories).to be_kind_of(Array)
		end

		it 'should contain a list of elements' do
			expect(categories.length).to be >= 0
		end
	end
end
