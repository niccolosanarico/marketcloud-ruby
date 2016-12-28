require 'faraday'
require 'json'

module Marketcloud
	class Shipping
		attr_accessor :name,
									:id,
									:price,
									:response

		#
		#
		#
		def initialize(attributes, response)
			@id = attributes['id']
			@name = attributes['name']
			@price = attributes['price']
			@response = response
		end

		#
		#
		#
		def self.find(id)
      query = Faraday.new(url: "#{API_URL}/shippings/#{id}") do |faraday|
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



		#
		#
		#
		def self.all()
			query = Faraday.new(url: "#{API_URL}/shippings") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
			end

      shippings = JSON.parse(response.body)

			#return a list of shippings
			shippings['data'].map { |s| new(s, response) }

		end

	end
end
