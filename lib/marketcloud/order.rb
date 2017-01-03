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
									:products,
									:currency_id

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
			@products = attributes['products']
			@currency_id = attributes['currency_id']
		end


		def self.cache_me?
      false
    end

		# Find a order by ID
		# @param id [Integer] the ID of the order
		# @return a Order or nil
		def self.find(id)
			order = perform_request api_url("orders/#{id}"), :get, nil, true

			if order
				new order['data']
			else
				nil
			end
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
		def self.create(user_id, cart_id, shipping_address_id, billing_address_id, shipping_id)
			order = perform_request api_url("orders", {}), :post,
						{
							user_id: user_id,
							cart_id: cart_id,
							shipping_address_id: shipping_address_id,
							billing_address_id: billing_address_id,
							shipping_id: shipping_id
						}, true

			if order
				new order['data']
			else
				nil
			end
		end
	end
end
