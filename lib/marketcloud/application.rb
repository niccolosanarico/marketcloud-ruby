require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Application < Request		
		def initialize(attributes)
			# Quick fix for a not ideal design decision on the API
			if attributes.kind_of? Array
				attributes = attributes.first
			end

			super
		end

		def self.plural
			# Yes, this end point does not need pluralization. Second not ideal design decision
			"application"
		end

	end
end
