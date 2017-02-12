require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Shipping < Request

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
