require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Product do
	let(:prod_id) { 107226 }
	let(:cat_id) { 107225 }

	describe 'a GET on a valid product' do
	  let(:product) { VCR.use_cassette('product') { Marketcloud::Product.find(prod_id) }}

		it 'should return 200' do
			expect(product.response.status).to eq 200
		end

		it 'answers to find with a valid product' do
		  expect(product.name).to eq "Pentola"
		end

	end

	describe 'a GET on all products' do
		let(:products) { VCR.use_cassette('products') { Marketcloud::Product.all }}

		it 'answers with an array' do
		  expect(products).to be_kind_of(Array)
		end

		it 'returns 200' do
			expect(products.first.response.status).to eq 200
		end
	end

	describe 'a GET on products by category' do
		let(:products) { VCR.use_cassette('products_by_category') { Marketcloud::Product.find_by_category(cat_id) }}

		it 'answers with an array' do
		  expect(products).to be_kind_of(Array)
		end

		it 'returns 200' do
			expect(products.first.response.status).to eq 200
		end
	end
end
