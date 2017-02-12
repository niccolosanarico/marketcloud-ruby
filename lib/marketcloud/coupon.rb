require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Coupon < Request

		# https://www.marketcloud.it/documentation/rest-api/coupons
								#	:target_type,  # CART_COUPON, PRODUCT_COUPON, CATEGORY_COUPON
								#	:discount_type,# NET_REDUCTION, PERCENTAGE_DISCOUNT
								#	:discount_value, #if PERCENTAGE_DISCOUNT, than a %, else an absolute number							

		def self.plural
			"coupons"
		end

	end
end
