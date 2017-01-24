require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Collection do
	let(:col_id) { 114237 }

	describe 'a GET on a valid colletion' do
		let(:collection) { VCR.use_cassette('collection_ok') { Marketcloud::Collection.find(col_id) }}

		it 'should return 200' do
			expect(collection).not_to be_nil
		end

		it 'answers to find with a valid collection' do
		  expect(collection.name).to eq "Home page"
		end

		it 'should have an array of Products' do
		  expect(collection.products).to be_kind_of(Array)
		end

	end

	describe 'a GET on an invalid url for a collection' do
		let(:collection) { VCR.use_cassette('collection_ko') { Marketcloud::Collection.find(-1) }}

		it 'should return nil' do
			expect(collection).to be_nil
		end
	end

	describe 'a GET on an invalid collection' do
		let(:collection) { VCR.use_cassette('collection_no') { Marketcloud::Collection.find(1) }}

		it 'should return nil' do
			expect(collection).to be_nil
		end
	end

	describe 'a GET for a paginated list of categories' do
		let(:collections) { VCR.use_cassette('collection_list_paginated') { Marketcloud::Collection.all() }}

		it 'should return an array' do
			expect(collections).to be_kind_of(Array)
		end

		it 'should contain a list of elements' do
			expect(collections.length).to be >= 0
		end
	end
end
