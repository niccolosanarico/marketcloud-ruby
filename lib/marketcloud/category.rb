require 'faraday'
require 'json'

module Marketcloud
	class Category
		attr_accessor :name,
									:id,
									:description,
									:url,
									:image_url,
									:parent_id,
									:response

		def initialize(attributes, response)

			if !attributes.nil?
				@id = attributes['id']
				@name = attributes['name']
				@description = attributes['description']
				@url = attributes['url']
				@image_url = attributes['image_url']
				@parent_id = attributes['parent_id']
			end

			@response = response
		end


		def self.find(id)
      query = Faraday.new(url: "#{API_URL}/categories/#{id}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = Marketcloud.configuration.public_key
			end

      attributes = JSON.parse(response.body)

			#return a product
			new(attributes['data'], response)
    end
	end
end
