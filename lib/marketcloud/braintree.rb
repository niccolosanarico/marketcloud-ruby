require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Braintree < Request
		attr_accessor :token

		def initialize(attributes)
			if !attributes.nil?
				@token = attributes['clientToken']
			end
		end


		# Create a new braintree token
		# @param user_id [Integer] the user for which the token is being created
		# @return an object with the token
		def self.get_token(user_id = nil)
			braintree = perform_request api_url("integrations/braintree/clientToken", {}), :post, { customer_id: user_id }, false

			if braintree
				new braintree['data']
			else
				nil
			end
		end
	end
end
