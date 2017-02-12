require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Category < Request

		def self.plural
			"categories"
		end


		# Return all the categories
		# @return an array of Categories
		def self.all()
			categories = perform_request(api_url("categories"), :get, nil, true, {})

			if categories
				categories['data'].map { |p| new(p) }
			else
				nil
			end
		end

	end
end
