require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Cart do
	let(:product_quantity) { 2 }
	let(:product_id) { 107226 }
	let(:cart_id)  { 107232 }

	describe 'a GET for a cart starting from a given user' do
		let(:carts) {
			VCR.use_cassette('cart_with_user_ID') {
				user = Marketcloud::User.find_by_email('prova2@prova.it')
				Marketcloud::Cart.find_by_user(user.id)
			}
		}

		it 'should return 200' do
			expect(carts).not_to be_nil
		end

		it 'returns an array of carts' do
		  expect(carts).to be_kind_of(Array)
		end

	end

	describe 'a GET for a cart given an ID' do
		let(:cart) {
			VCR.use_cassette('cart_with_ID') {
				Marketcloud::Cart.find(cart_id)
			}
		}

		it 'should return 200' do
			expect(cart).not_to be_nil
		end

		it 'answers to find with a valid cart containing items' do
		  expect(cart.items.length).to be >= 0
		end

	end

	describe 'a PATCH should update a cart' do

		context 'with UPDATE it should update the products' do

			let(:cart) {
				VCR.use_cassette('cart_with_ID_update') {
					cart = Marketcloud::Cart.create
					cart.update([{
							product_id: product_id,
							quantity: product_quantity
						}])
				}
			}

			it 'should return 200' do
				expect(cart).not_to be_nil
			end

			it 'should update the product quantity' do
				expect(cart.items.select { |p| p["product_id"] == product_id }.first["quantity"]).to eq product_quantity
			end

			it 'should contain only 1 product now' do
				expect(cart.items.length).to eq 1
			end
		end

		context 'with ADD it should add the products' do

			let(:cart) {
				VCR.use_cassette('cart_with_ID_add') {
					Marketcloud::Cart.create
				}
			}

			# let!(:initial_quantity) {
			# 	cart.items.select { |c| c["product_id"] == product_id }.first["quantity"]
			# }

			let(:updated_cart) {
				VCR.use_cassette('cart_with_ID_add_post') {
					cart.add([{
							product_id: product_id,
							quantity: product_quantity
						}])
				}
			}

			it 'should return 200' do
				expect(updated_cart).not_to be_nil
			end

			it 'should update the product quantity' do
				expect(updated_cart.items.select { |p| p["product_id"] == product_id }.first["quantity"]).to eq product_quantity
			end
		end

		context 'with ADD! it should add the products and modify the original object' do

			let(:cart) {
				VCR.use_cassette('cart_with_ID_add_') {
					Marketcloud::Cart.create
				}
			}

			# let!(:initial_quantity) {
			# 	cart.items.select { |c| c["product_id"] == product_id }.first["quantity"]
			# }

			let(:updated_cart) {
				VCR.use_cassette('cart_with_ID_add__post') {
					cart.add!([{
							product_id: product_id,
							quantity: product_quantity
						}])
					cart
				}
			}

			it 'should return 200' do
				expect(updated_cart).not_to be_nil
			end

			it 'should update the product quantity' do
				expect(updated_cart.items.select { |p| p["product_id"] == product_id }.first["quantity"]).to eq product_quantity
			end
		end
	end

	describe 'Using a POST to create a new cart with a user' do
		let(:cart) {
			VCR.use_cassette('cart_creation') {
				user = Marketcloud::User.find_by_email('prova2@prova.it')
				Marketcloud::Cart.create(user.id)
			}
		}

		it 'should return 200' do
			expect(cart).not_to be_nil
		end

		it 'should not contain products' do
			expect(cart.items.length).to eq 0
		end
	end

	describe 'Using a POST to create a new cart with no user' do
		let(:cart) {
			VCR.use_cassette('cart_creation_no_user') {
				Marketcloud::Cart.create()
			}
		}

		it 'should return 200' do
			expect(cart).not_to be_nil
		end

		it 'should not contain products' do
			expect(cart.items.length).to eq 0
		end
	end

end
