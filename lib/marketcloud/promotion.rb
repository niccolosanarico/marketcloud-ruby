require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Promotion < Request

		# https://www.marketcloud.it/documentation/rest-api/promotions
		attr_accessor :name, :id,
									:conditions,
									:effects,
									:active

		def initialize(attributes)
			@id = attributes['id']
			@name = attributes['name']
			@conditions = attributes['conditions'].map { |cond| Condition.new(cond["type"], cond["value"]) }
			@effects = attributes['effects'].map { |eff| Effect.new(eff["type"], eff["value"]) }
			@active = attributes['active']
		end

		# Find a promotion by ID
		# @param id [Integer] the ID of the promotion
		# @return a promotion or nil
		def self.find(id)
			prom = perform_request api_url("promotions/#{id}"), :get, nil, true

			if prom
				new prom['data']
			else
				nil
			end
		end

		class Condition
			# The type of the condition, possible values are 'MIN_NUMBER_OF_PRODUCTS' triggered when
			# the cart has at least a certain number of products, 'MIN_CART_VALUE' triggered when the total
			# value of the products in cart is greater than or equal to a certain value, 'CART_HAS_ITEM'
			# when the cart contain a certain item.
			attr_accessor :type, :value

			def initialize type, value
				@type = type
				@value = value
			end
		end

		class Effect
			# The type of the effect, possible values are 'CART_VALUE_PERCENTAGE_REDUCTION' will
			# reduce the total cart value by a percentage value, 'CART_VALUE_NET_REDUCTION'
			# will redduce the total cart value by a fixed value, 'CART_ITEMS_NET_REDUCTION' will
			# reduce only the value of items by a fixed value, 'CART_ITEMS_PERCENTAGE_REDUCTION'
			# will reduce only the value of items by a percentage value, FREE_SHIPPING will discount the value of shipping.
			attr_accessor :type, :value

			def initialize type, value
				@type = type
				@value = value
			end
		end
	end
end
