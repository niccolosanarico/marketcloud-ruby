require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Collection < Request
		attr_accessor :products

		def initialize(attributes)
			super(attributes)

			if !attributes.nil?
				@products = attributes['items'].map { |item| Marketcloud::Product.new(item) }
			end
		end


		def self.plural
			"collections"
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

		# Return all the collections
		# @return an array of Collections
		def self.all()
			collections = perform_request(api_url("collections"), :get, nil, true, {})

			if collections
				collections['data'].map { |c| new(c) }
			else
				nil
			end
		end

	end
end
