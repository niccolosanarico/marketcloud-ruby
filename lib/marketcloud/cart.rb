require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Cart < Request

		# INSTANCE METHODS

		# Returns a new cart with updated items. Modifies the caller!
		# @param items [Array] the items to be inserted
		# @return a new cart
		def update!(items)
			cart = Cart.perform_request Cart.api_url("carts/#{self.id}", {}), :patch,
				{ op: "update",
					items: items.map { |item| { product_id: item[:product_id], quantity: item[:quantity], variant_id: item[:variant_id] }
				}}, true

			if cart
				self.items = cart["data"]["items"]
			else
				false
			end
		end

		# Adds items to a cart
		# @param items [Array] the items to be added
		# @return a new cart
		def add(items)
			cart = Cart.perform_request Cart.api_url("carts/#{self.id}", {}), :patch,
				{ op: "add",
					items: items.map { |item| { product_id: item[:product_id], quantity: item[:quantity], variant_id: item[:variant_id] }
				}}, true

			if cart
				Cart.new(cart["data"])
			else
				false
			end
		end

		# Adds items to a cart (modifies the caller!)
		# @param items [Array] the items to be added
		# @return a new cart
		def add!(items)
			cart = Cart.perform_request Cart.api_url("carts/#{self.id}", {}), :patch,
				{ op: "add",
					items: items.map { |item| { product_id: item[:product_id], quantity: item[:quantity], variant_id: item[:variant_id] }
				}}, true

			if cart
				self.items = cart["data"]["items"]
			else
				false
			end
		end

		# Adds a user to the cart (modifies the caller!)
		# @param user_id the user who created the cart
		# @return a new cart
		def update_user!(user_id)
			cart = Cart.perform_request Cart.api_url("carts/#{self.id}", {}), :put,
				{
					user_id: user_id,
					items: self.items
				}, true

			if cart
				self.user_id = user_id
			else
				false
			end
		end

		# Removes items from a cart (modifies the caller!)
		# @param product_ids [Array] the products to be removed
		# @return a new cart
		def remove!(product_ids)
			cart = Cart.perform_request Cart.api_url("carts/#{self.id}", {}), :patch,
				{ op: "remove",
					items: product_ids }, true

			if cart
				self.items = cart["data"]["items"]
			else
				false
			end
		end

		# CLASS METHODS

		def self.cache_me?
      false
		end

		def self.plural
			"carts"
		end

		# Find all the carts belonging to a user
		# @param user_id [Integer] the user ID
		# @return an array of Cart or nil
		def self.find_by_user(user_id)
			carts = perform_request api_url("carts", { user_id: user_id }), :get, nil, true

			if carts
				carts['data'].map { |a| new(a) }
			else
				nil
			end
		end

		# Create a new cart with no items and optional user
		# @param user_id [Integer] the user to which the cart belogns (optional)
		# @return the newly created cart
		def self.create(user_id=nil)
			cart = perform_request api_url("carts", {}), :post, { user_id: user_id, items: [] }, true

			if cart
				new cart['data']
			else
				nil
			end
		end
	end
end
