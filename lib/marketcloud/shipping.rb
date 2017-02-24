require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Shipping < Request
		attr_accessor :max_depth, :min_depth, :max_width, :min_width, :max_height, :min_height, :max_weight, :min_weight, :min_value, :max_value

		#
		#
		# A bit of dirty approach to initialize values
		def initialize(attributes)
			super

			# The wrapper to the API does not judge original values, so I initialize them here
			@max_weight ||= 100000000000
			@min_weight ||= 0
			@max_depth  ||= 100000000000
			@min_depth 	||= 0
			@max_height ||= 100000000000
			@min_height ||= 0
			@max_width 	||= 100000000000
			@min_width 	||= 0
			@max_value 	||= 100000000000
			@min_value 	||= 0

		end

		def self.plural
			"shippings"
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
