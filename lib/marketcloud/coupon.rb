require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Coupon < Request

		# https://www.marketcloud.it/documentation/rest-api/coupons
		attr_accessor :name, :id, :code,
									:target_type,  # CART_COUPON, PRODUCT_COUPON, CATEGORY_COUPON
									:discount_type,# NET_REDUCTION, PERCENTAGE_DISCOUNT
									:discount_value, #if PERCENTAGE_DISCOUNT, than a %, else an absolute number
									:active

		def initialize(attributes)
			@id = attributes['id']
			@name = attributes['name']
			@code = attributes['code']
			@target_type = attributes['target_type']
			@discount_type = attributes['discount_type']
			@discount_value = attributes['discount_value']
			@active = attributes['active']
		end

		def self.plural
			"coupons"
		end

	end
end
