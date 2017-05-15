require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Order < Request

		def self.cache_me?
      false
		end

		def self.plural
			"orders"
		end


		# Find all the orders belonging to a user
		# @param user_id [Integer] the user ID
		# @return an array of Order or nil
		def self.find_by_user(user_id)
			orders = perform_request api_url("orders", { user_id: user_id }), :get, nil, true

			if orders
				orders['data'].map { |a| new(a) }
			else
				nil
			end
		end

		# Create a new order
		# @param user_id [Integer] the user to which the order belongs
		# @param cart_id [Integer] the cart for the order
		# @param shipping_address_id [Integer] the shipping address
		# @param billing_address_id [Integer] the billing address
		# @param shipping_id [Integer] the shipping ID
		# @return the newly created order
		def self.create(user_id, cart_id, shipping_address_id, billing_address_id, shipping_id, promotion_id = nil, coupon_code = nil)

			fields = {
				user_id: user_id,
				cart_id: cart_id,
				shipping_address_id: shipping_address_id,
				billing_address_id: billing_address_id,
				shipping_id: shipping_id
			}

			if promotion_id; fields[:promotion_id] = promotion_id end
			if coupon_code; fields[:coupon_code] = coupon_code end

			order = perform_request api_url("orders", {}), :post,
						fields, true

			if order
				new order['data']
			else
				nil
			end
		end

		# delete a order by ID
		# @param id [Integer] the ID of the order
		# @return a true in case of success
		def self.delete(id)
			order = perform_request api_url("orders/#{id}"), :delete, nil, true

			if order["status"] == true
				true
			else
				false
			end
		end

	end
end
