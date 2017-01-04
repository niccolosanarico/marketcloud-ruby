require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Application < Request
		attr_accessor :name, :id, :tax_rate, :currency_code, :logo, :timezone

		def initialize(attributes)
			@id = attributes['id']
			@name = attributes['name']
			@tax_rate = attributes['tax_rate']
			@currency_code = attributes['currency_code']
			@logo = attributes['logo']
			@timezone = attributes['timezone']
		end

		# Find an application
		# @return a Application or nil
		def self.find()
			app = perform_request api_url("application"), :get, nil, false

			if app
				new app['data'].first
			else
				nil
			end
		end
	end
end
