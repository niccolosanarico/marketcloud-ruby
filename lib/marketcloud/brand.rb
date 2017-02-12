require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Brand < Request

		def self.plural
			"brands"
		end

		# Return all the brands
		# @return an array of Brands
		def self.all()
			brands = perform_request(api_url("brands"), :get, nil, true, {})

			if brands
				brands['data'].map { |p| new(p) }
			else
				nil
			end
		end

	end
end
