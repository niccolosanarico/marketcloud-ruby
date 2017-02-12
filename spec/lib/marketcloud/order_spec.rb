require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Order do
	let(:user_id) { 107227 }
	let(:prod_id) { 107226 }
	let(:order_id) { 107236 }
	let(:order_to_delete) { 108910 }
	let(:shipping_address_id) { 107234 }
	let(:billing_address_id) { 107234 }
	let(:shipping_id) { 107233 }

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
			expect(order).not_to be_nil
		end
	end

	describe 'a GET for a valid order from a user_id' do
		let(:orders) {
			VCR.use_cassette('orders_by_user') {
				Marketcloud::Order.find_by_user(user_id)
			}
		}

		it 'should return 200' do
			expect(orders).not_to be_nil
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
			expect(new_order).not_to be_nil
		end

		it 'should return an order in the "created" phase' do
			expect(new_order.status).to eq "pending"
		end
	end

	describe 'a DELETE to delete an order' do
		let(:delete_order) {
			VCR.use_cassette('order_delete') {
				Marketcloud::Order.delete(order_to_delete)
			}
		}

		it 'should return success' do
			expect(delete_order).to eq true
		end

		it 'should have deleted the order' do
			expect( VCR.use_cassette('order_check_deletion') {
				Marketcloud::Order.find(order_to_delete)
			} ).to be_nil
		end
	end
end
