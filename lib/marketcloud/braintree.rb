require 'faraday'
require 'json'

module Marketcloud
	class Braintree
		attr_accessor :token,
									:response

		def initialize(attributes, response)

			if !attributes.nil?
				@token = attributes['clientToken']
			end

			@response = response
		end


		def self.get_token(user_id = nil)
      query = Faraday.new(url: "#{API_URL}/integrations/braintree/clientToken") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			response = query.post do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = Marketcloud.configuration.public_key
				req.body = {
					customer_id: user_id
				}.to_json
			end

      attributes = JSON.parse(response.body)

			#return a product
			new(attributes['data'], response)
    end
	end
end
