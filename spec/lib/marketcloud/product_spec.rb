require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Product do
	let(:prod_id) { 107226 }
	let(:prod_id_with_variant) { 109263 }
	let(:cat_id) { 107225 }

	describe 'a GET on a valid product' do
	  let(:product) { VCR.use_cassette('product') { Marketcloud::Product.find(prod_id) }}

		it 'should return 200' do
			expect(product).not_to be_nil
		end

		it 'answers to find with a valid product' do
		  expect(product.name).to eq "Pentola"
		end
	end

	describe 'a GET on a valid product with variants' do
	  let(:variant_product) { VCR.use_cassette('product_with_variants') { Marketcloud::Product.find(prod_id_with_variant) }}

		it 'should return 200' do
			expect(variant_product).not_to be_nil
		end

		it 'answers to find with a valid product' do
		  expect(variant_product.name).to eq "Ardesia (Quadrata)"
		end

		it 'should have variants' do
		  expect(variant_product.has_variants).to be true
		end

		it 'should have variant objects' do
		  expect(variant_product.variants.first).to be_kind_of Marketcloud::Variant
		end
	end

	describe 'a GET on all products' do
		let(:products) { VCR.use_cassette('products') { Marketcloud::Product.all }}

		it 'answers with an array' do
		  expect(products).to be_kind_of(Array)
		end

		it 'returns 200' do
			expect(products).not_to be_nil
		end
	end

	describe 'a GET on products by category' do
		let(:products) { VCR.use_cassette('products_by_category') { Marketcloud::Product.find_by_category(cat_id) }}

		it 'answers with an array' do
		  expect(products).to be_kind_of(Array)
		end

		it 'returns 200' do
			expect(products).not_to be_nil
		end
	end

	describe 'a POST to create a new product' do
		let(:new_product) { {name: 'a product', description: 'With a name', price: 99.99, sku: 'XXXXYYQQQ', stock_type: 'status', stock_status: "in_stock"} }
		let(:created_product) { VCR.use_cassette('product_new') { Marketcloud::Product.create(new_product) }}

		it 'is successfull' do
			expect(created_product).not_to be_nil
		end

		it 'creates a new product' do
			expect(created_product.name).to eq new_product[:name]
		end
	end

	describe 'a PUT to update a product' do
		let(:product_to_update) { 132169 }
		let(:update_product) { {name: 'a product', description: 'With an updated name' } }
		let(:updated_product) { VCR.use_cassette('product_update') { Marketcloud::Product.update(product_to_update, update_product) }}

		it 'is successfull' do
			expect(updated_product).not_to be_nil
		end

		it 'returns an updated product' do
			expect(updated_product.description).to eq update_product[:description]
		end
	end
end
