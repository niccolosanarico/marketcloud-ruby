require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Category < Request

		attr_accessor :meta, :facebook, :parent_id

		def initialize(attributes)
			super

			# A bit of ad-hoc initializations for the category
			@meta = attributes['seo']['meta'] unless attributes['seo'].nil? #title #keywords #description
			@facebook = attributes['seo']['facebook'] unless attributes['seo'].nil? #title #description #image
		end

		def self.plural
			"categories"
		end

		# Find an object by ID - need to instantiate it here to call the righr initializer
		# @param id [Integer] the ID of the object
		# @return an object or nil
		def self.find(id = nil)
			object = perform_request api_url("#{self.plural}/#{id}"), :get, nil, true

			if object
				new object['data']
			else
				nil
			end
		end

		# Return all the categories
		# @param page the page you want to query for
		# @param per_page how many items per page
		# @return an array of Categories
		def self.all(page: 1, per_page: 200, sort_by: "", sort_order: "")
			query = {
				per_page: per_page,
				page: page,
				sort_by: sort_by,
				sort_order: sort_order
			}
			categories = perform_request(api_url(self.plural, query), :get, nil, true)

			if categories
				categories['data'].map { |cs| new(cs) }
			else
				nil
			end
		end

		# Create a new category and returns it
		# @param category a hash with the category
		# @return a new category
		def self.create(category)
			cat = perform_request(api_url("categories"), :post, category, true)

			if cat
				new(cat['data'])
			else
				nil
			end
		end

		# Update a category and returns it
		# @param id the id of an existing category
		# @param category a hash with the category
		# @return the updated	category
		def self.update(id, category)
			c = perform_request(api_url("#{self.plural}/#{id}"), :put, category, true)

			if c
				new(c['data'])
			else
				nil
			end
		end
	end
end
