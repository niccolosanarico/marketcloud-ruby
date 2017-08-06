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

    # Find a coupon by code
    # @param code [String] the coupon code
    # @return a coupon or nil
    def self.find_by_code(code)
      query = {
        code: code
      }

      coupon = perform_request(api_url("coupons",
                                        query), :get, nil, true)

      if coupon['data'].length > 0
          new(coupon['data'].first)
      else
        nil
      end
    end
	end
end
