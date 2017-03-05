require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Brand < Request

		def self.plural
			"brands"
		end

		# Return all the brands
		# @param page the page you want to query for
		# @param per_page how many items per page
		# @return an array of Brands
		def self.all(page: 1, per_page: 200)
			query = {
				per_page: per_page,
				page: page,
			}
			brands = perform_request(api_url(self.plural, query), :get, nil, true, {})

			if brands
				brands['data'].map { |p| new(p) }
			else
				nil
			end
		end

		# Create a new brand and returns it
		# @param brand a hash with the brand
		# @return a new brand
		def self.create(brand)
			b = perform_request(api_url(self.plural), :post, brand, true)

			if b
				new(b['data'])
			else
				nil
			end
		end

		# Update a brand and returns it
		# @param id the id of the brand to be updated
		# @param brand a hash with the brand
		# @return the updated	 brand
		def self.update(id, brand)
			b = perform_request(api_url("#{self.plural}/#{id}"), :put, brand, true)

			if b
				new(b['data'])
			else
				nil
			end
		end
	end
end
