require 'faraday'
require 'json'

module Marketcloud
	class Configuration
    attr_accessor :public_key, :private_key

    def initialize(public = nil, private = nil)
      @public_key ||= public
			@private_key ||= private
    end
  end
end
