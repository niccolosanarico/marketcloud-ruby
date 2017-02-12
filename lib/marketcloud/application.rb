require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Application < Request
		attr_accessor :name, :id, :tax_rate, :currency_code, :logo, :timezone, :tax_type

		def initialize(attributes)
			# Quick fix for a bad design decision on the API
			if attributes.kind_of? Array
				attributes = attributes.first
			end

			@id = attributes['id']
			@name = attributes['name']
			@tax_rate = attributes['tax_rate']
			@tax_type = attributes['tax_type']  # all, products_only, shipping_only, nothing
			@currency_code = attributes['currency_code']
			@logo = attributes['logo']
			@timezone = attributes['timezone']
		end

		def self.plural
			# Yes, this end point does not need pluralization
			"application"
		end

	end
end
