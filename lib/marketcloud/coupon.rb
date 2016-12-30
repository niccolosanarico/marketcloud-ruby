require 'faraday'
require 'json'

module Marketcloud
	class Coupon
		attr_accessor :name, :id, :code

		def initialize(attributes)
			@id = attributes['id']
			@name = attributes['name']
			@code = attributes['code']
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

			if response.status != 200
				Marketcloud.logger.error(response.body)
				return nil
			end

      attributes = JSON.parse(response.body)
			#return a coupon
			new(attributes['data'])
    end
	end
end
