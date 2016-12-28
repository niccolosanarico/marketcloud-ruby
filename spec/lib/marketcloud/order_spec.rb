require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Order do
	let(:user_id) { 105690 }
	let(:prod_id) { 11744 }
	let(:order_id) { 106869 }
	let(:shipping_address_id) { 106859 }
	let(:billing_address_id) { 106859 }
	let(:shipping_id) { 106867 }

	let(:cart) {
		VCR.use_cassette('order_new_cart') {
			cart = Marketcloud::Cart.create(user_id)
			cart.update!([{product_id: prod_id, quantity: 2}])
			cart
		}
	}

	describe 'a GET for a valid order' do
		let(:order) {
			VCR.use_cassette('order_get') {
				Marketcloud::Order.find(order_id)
			}
		}

		it 'should return 200' do
			expect(order.response.status).to eq 200
		end
	end

	describe 'a GET for a valid order from a user_id' do
		let(:orders) {
			VCR.use_cassette('orders_by_user') {
				Marketcloud::Order.find_by_user(user_id)
			}
		}

		it 'should return 200' do
			expect(orders.first.response.status).to eq 200
		end

		it 'should return an array' do
			expect(orders).to be_kind_of(Array)
		end
	end

	describe 'a POST to create a new order' do
		let(:new_order) {
			VCR.use_cassette('order_create') {
				Marketcloud::Order.create(user_id, cart.id, shipping_address_id, billing_address_id, shipping_id)
			}
		}

		it 'should return 200' do
			expect(new_order.response.status).to eq 200
		end

		it 'should return an order in the "created" phase' do
			expect(new_order.status).to eq "pending"
		end
	end
end
