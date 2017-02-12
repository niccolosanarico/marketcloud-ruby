require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Payment < Request

		# Create a new payment
		# @param order_id [Integer] the ID of the order
		# @param nonce [String] the nonce from Braintree
		# @return True if the payment went through
		def self.create(order_id, nonce)
			payment = perform_request api_url("payments", {}), :post, { method: "Braintree", order_id: order_id, nonce: nonce }, true
			if payment
				new(payment)
			else
				nil
			end
		end
	end
end
