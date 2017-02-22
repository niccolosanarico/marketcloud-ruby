require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class PaymentMethod < Request

		def self.plural
			"paymentmethods"
		end

		# Return all the payment methods
		# @return an array of Payment methods
		def self.all()
			query = perform_request(api_url(self.plural), :get, nil, true, {})

			if query
				query['data'].map { |p| new(p) }
			else
				nil
			end
		end

	end
end
