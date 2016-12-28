require 'faraday'
require 'json'

module Marketcloud
	class Coupon
		attr_accessor :name, :id, :code, :response

		def initialize(attributes, response)
			@id = attributes['id']
			@name = attributes['name']
			@code = attributes['code']
			@response = response
		end


		#
		# Find a coupon by ID
		#
		def self.find(id)
      query = Faraday.new(url: "#{API_URL}/coupons/#{id}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
			end

      attributes = JSON.parse(response.body)

			#return a coupon
			new(attributes['data'], response)
    end
	end
end
