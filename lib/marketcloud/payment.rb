require 'faraday'
require 'json'

module Marketcloud
	class Payment

		def initialize()

		end

		def self.create(order_id, nonce)
      query = Faraday.new(url: "#{API_URL}/payments") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			response = query.post do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = Marketcloud.configuration.public_key
				req.body = {
					method: "Braintree",
					order_id: order_id,
					nonce: nonce
				}.to_json
			end

      attributes = JSON.parse(response.body)

			if response.status != 200
				Marketcloud.logger.error(response.body)
				return nil
			end

			return true
    end
	end
end
