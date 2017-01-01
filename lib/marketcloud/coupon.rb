require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Coupon < Request
		attr_accessor :name, :id, :code

		def initialize(attributes)
			@id = attributes['id']
			@name = attributes['name']
			@code = attributes['code']
		end

		# Find a coupon by ID
		# @param id [Integer] the ID of the coupon
		# @return a Coupon or nil
		def self.find(id)
			coupon = perform_request api_url("coupons/#{id}"), :get, nil, true

			if coupon
				new coupon['data']
			else
				nil
			end
		end
	end
end
