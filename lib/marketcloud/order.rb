require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Order < Request
		attr_accessor :id,
									:cart_id,
									:status,
									:shipping_address,
									:billing_address,
									:shipping_id,
									:user_id,
									:store_id,
									:items_total,
									:display_total,
									:display_items_total,
									:shipping_total,
									:taxes_total,
									:total,
									:items,
									:products,
									:currency_id,
									:created_at,
									:promotion_id,
									:coupon_code

		#
		#
		#
		def initialize(attributes)
			@id = attributes['id']
			@user_id = attributes['user_id']
			@status = attributes['status']
			@shipping_address = attributes['shipping_address']
			@billing_address = attributes['billing_address']
			@shipping_id = attributes['shipping_id']
			@user_id = attributes['user_id']
			@store_id = attributes['store_id']
			@items_total = attributes['items_total']
			@display_total = attributes['display_total']
			@display_items_total = attributes['display_items_total']
			@shipping_total = attributes['shipping_total']
			@taxes_total = attributes['taxes_total']
			@total = attributes['total']
			@items = attributes['items']
			@products = attributes['products']
			@currency_id = attributes['currency_id']
			@created_at = attributes['created_at']
			@promotion_id = attributes['promotion_id']
			@coupon_code = attributes['coupon_code']
		end


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
			order = perform_request api_url("orders", {}), :post,
						{
							user_id: user_id,
							cart_id: cart_id,
							shipping_address_id: shipping_address_id,
							billing_address_id: billing_address_id,
							shipping_id: shipping_id,
							promotion_id: promotion_id,
							coupon_code: coupon_code
						}, true

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
