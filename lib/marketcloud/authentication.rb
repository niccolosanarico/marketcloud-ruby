require 'faraday'
require 'json'
require 'digest'

module Marketcloud
	class Authentication

		attr_accessor :token

		#
		#
		#
		def initialize(token)
      @token = token
		end

		#
		#
		#
		def self.get_token(config = Configuration.new)
      timestamp = Time.now.to_i

      hash = Digest::SHA256.base64digest "#{Marketcloud.configuration.private_key}#{timestamp}"

      query = Faraday.new(url: "#{API_URL}/tokens") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				# faraday.response :logger                  # log requests to STDOUT
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			response = query.post do |req|
			  req.headers['content-type'] = 'application/json'
        req.headers['accept'] = 'application/json'
        req.body = {
          publicKey: Marketcloud.configuration.public_key,
          secretKey: hash,
          timestamp: timestamp
        }.to_json

				# puts "Request: #{req.body}"
			end

      # puts "Response: #{response.body}"

      resp = JSON.parse(response.body)

			if response.status != 200
				return nil
			end

			token = resp["token"]
			#return a token
			new(token)
    end
	end
end
