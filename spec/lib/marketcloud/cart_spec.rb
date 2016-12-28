require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Cart do
	let(:product_quantity) { 2 }
	let(:product_id) { 105688 }
	let(:cart_id)  { 106825 }

	describe 'a GET for a cart starting from a given user' do
		let(:carts) {
			VCR.use_cassette('cart_with_user_ID') {
				user = Marketcloud::User.authenticate('prova@prova.it', 'provapw')
				Marketcloud::Cart.find_by_user(user.id)
			}
		}

		it 'should return 200' do
			expect(carts.first.response.status).to eq 200
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
			expect(cart.response.status).to eq 200
		end

		it 'answers to find with a valid cart containing items' do
		  expect(cart.items.length).to be >= 0
		end

	end

	describe 'a PUT should update a cart' do

		context 'with UPDATE it should update the products' do

			let(:cart) {
				VCR.use_cassette('cart_with_ID_update') {
					cart = Marketcloud::Cart.find(cart_id)
					cart.update!([{
							product_id: product_id,
							quantity: product_quantity
						}])
					cart
				}
			}

			it 'should return 200' do
				expect(cart.response.status).to eq 200
			end

			it 'should update the product quantity' do
				expect(cart.items.select { |p| p["product_id"] == product_id }.first["quantity"]).to eq product_quantity
			end

			it 'should contain only 1 product now' do
				expect(cart.items.length).to eq 1
			end
		end
	end

	describe 'Using a POST to create a new cart' do
		let(:cart) {
			VCR.use_cassette('cart_creation') {
				user = Marketcloud::User.authenticate('prova@prova.it', 'provapw')
				Marketcloud::Cart.create(user.id)
			}
		}

		it 'should return 200' do
			expect(cart.response.status).to eq 200
		end

		it 'should not contain products' do
			expect(cart.items.length).to eq 0
		end
	end

end
