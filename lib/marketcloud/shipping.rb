require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Shipping < Request
		attr_accessor :name,
									:id,
									:price

		#
		#
		#
		def initialize(attributes)
			@id = attributes['id']
			@name = attributes['name']
			@base_cost = attributes['base_cost']
		end

		# Find a shipping by ID
		# @param id [Integer] the ID of the shipping
		# @return a Shipping or nil
		def self.find(id)
			shipping = perform_request api_url("shippings/#{id}")

			if shipping
				new shipping['data']
			else
				nil
			end
		end



		# Return all the shippings
		# @return an array of Shippings
		def self.all()
			shippings = perform_request(api_url("shippings"), :get, nil, true)

			if shippings
				shippings['data'].map { |p| new(p) }
			else
				nil
			end
		end

	end
end
