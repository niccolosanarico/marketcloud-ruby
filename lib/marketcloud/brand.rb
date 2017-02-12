require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Brand < Request
		attr_accessor :name,
									:id,
									:description,
									:url,
									:img_url

		def initialize(attributes)

			if !attributes.nil?
				@id = attributes['id']
				@name = attributes['name']
				@description = attributes['description']
				@url = attributes['url']
				@img_url = attributes['img_url']
			end
		end

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
