require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Category < Request
		attr_accessor :name,
									:id,
									:description,
									:url,
									:image_url,
									:parent_id

		def initialize(attributes)

			if !attributes.nil?
				@id = attributes['id']
				@name = attributes['name']
				@description = attributes['description']
				@url = attributes['url']
				@image_url = attributes['image_url']
				@parent_id = attributes['parent_id']
			end
		end


		# Find a category by ID
		# @param id [Integer] the ID of the category
		# @return a Category
		def self.find(id)
			category = perform_request api_url("categories/#{id}")

			if category
				new category['data']
			else
				nil
			end
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
