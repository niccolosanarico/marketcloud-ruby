require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Promotion < Request
		attr_accessor :conditions, :effects
		# https://www.marketcloud.it/documentation/rest-api/promotions

		def initialize(attributes)
			super(attributes)
			# A bit of more educated item creation than basic initialization
			@conditions = @conditions.map { |cond| Condition.new(cond["type"], cond["value"]) } unless @conditions.nil?
			@effects = @conditions.map { |eff| Effect.new(eff["type"], eff["value"]) }	unless @effects.nil?
		end

		def self.plural
			"promotions"
		end

		# Find an object by ID - need to instantiate it here to call the righr initializer
		# @param id [Integer] the ID of the object
		# @return an object or nil
		def self.find(id = nil)
			object = perform_request api_url("#{self.plural}/#{id}"), :get, nil, true

			if object
				new object['data']
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
