require 'faraday'
require 'json'

module Marketcloud
	class Category
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


		def self.find(id)
      query = Faraday.new(url: "#{API_URL}/categories/#{id}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = Marketcloud.configuration.public_key
			end

			if response.status != 200
				return nil
			end

      attributes = JSON.parse(response.body)

			#return a product
			new(attributes['data'])
    end
	end
end
