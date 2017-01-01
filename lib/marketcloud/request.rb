require 'uri'
require 'faraday'
require 'faraday_middleware'
require 'json'

module Marketcloud
  class Request

    # Stub method. Each subclass should have its own api version
    # @return [String] api version
    def self.api_version
      "v0"
    end

    # Returns a full url for an API call
    # @param path [String] API path to call
    # @return [String] full fledged url
    def self.api_url path, params = {}
      url = "#{api_base_url}/#{self.api_version}/#{path}"
      "#{url}?#{api_query_string params}"
    end

    def self.api_base_url
      "http://api.marketcloud.it/"
    end

    def self.api_query_string params = {}
      URI.encode_www_form params
    end

    # Returns just a path from a full api url
    # @return [String]
    def self.clean_url(url)
      uri = URI.parse(url)
      uri.query = URI.encode_www_form(CGI.parse(uri.query || ''))
      uri.to_s
    end

    # Calls the API via Faraday and handles errors
    # @param url [String] the url to call
    # @param verb [Symbol] HTTP verb to use. Defaults to :get
    # @param body [Hash] Body for POST request
    # @param need_token [Boolean] True if need authentication token
    # @param options [Hash] Options passed to HTTParty
    # @return [String] raw response of the call
    def self.perform_request url, verb = :get, body = nil, need_token = false, options = {}
      options_id = options.inspect

      can_cache = [:post, :put, :patch].include?(verb) ? false : cached?

      if can_cache && result = store.get("#{clean_url(url)}#{options_id}")
        return JSON.parse(result)
      end

      response = perform_uncached_request url, verb, body, need_token, options

      store.setex "#{clean_url(url)}#{options_id}", ttl, response.body.to_json if can_cache && !response.nil?
      return response.body unless response.nil?
      nil
    end


    def self.perform_uncached_request url, verb = :get, body = nil, need_token = false, options = {}

      query = Faraday.new(url: "#{url}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
        faraday.response :json
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			response = query.send(verb) do |req|
			  req.headers['Content-Type']   = 'application/json'
        req.headers["Accept"]         = "application/json"

        if need_token
          auth = Marketcloud::Authentication.get_token()
          req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
        else
		      req.headers['Authorization']  = Marketcloud.configuration.public_key
        end

        if [:post, :put, :patch].include?(verb)
          req.body = body.to_json if body
        end
			end

      if response.status != 200
        # raise NotFound.new(response.body) if response.status == 404
				raise Anauthorized.new(response.body) if response.status == 401
        if response.status == 400
          if response.body["errors"].select { |e| e["type"] == "EmailAddressExists"}.length >= 1
            raise ExistingUserError.new(response.body)
          # else
          #   raise BadRequest.new(response.body)
          end
        end

				Marketcloud.logger.error(response.body)
				return nil
			end

      response
    end

    # @return [Redis] returns the cache store
    def self.store
      Marketcloud.configuration.cache_store[:redis]
    end

    # @return [Boolean] true if the request should be cached
    def self.cached?
      Marketcloud.configuration.cache_store[:cached]
    end

    # @return [Fixnum] the ttl to apply to cached keys
    def self.ttl
      Marketcloud.configuration.cache_store[:ttl]
    end

  end
end
