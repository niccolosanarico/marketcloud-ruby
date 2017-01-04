require 'faraday'
require 'json'
require 'redis'

module Marketcloud
	class Configuration
    attr_accessor :public_key, :private_key, :application

    def initialize(public = nil, private = nil, options = {})
      @public_key ||= public
			@private_key ||= private

			set_up_cache(options.delete(:redis), options.delete(:ttl))
    end

		def set_up_cache(redis_url, ttl)
      return @cached = false unless redis_url

      @ttl = ttl || 900
      @cached = true
      @redis = Redis.new :url => redis_url
		end

		def cache_store
      {
        redis:  @redis,
        ttl:    @ttl,
        cached: @cached,
      }
		end
	end
end
