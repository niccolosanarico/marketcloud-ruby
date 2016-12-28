require 'faraday'
require 'json'

module Marketcloud
	class User
		attr_accessor :name, :id, :email, :image_url,
									:response, :token

		# INSTANCE METHODS

		#
		#
		#
		def initialize(id, name, email, image_url, token, response)
			@id = id
			@name = name
			@email = email
			@token = token
			@image_url = image_url
			@response = response
		end


		#
		#
		#
		def authenticated?
			return !self.token.nil?
		end


		# CLASS METHODS

		#
		#
		#
		def self.find(id)
      query = Faraday.new(url: "#{API_URL}/users/#{id}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
			end

      attributes = JSON.parse(response.body)

			#return a user
			new(attributes['data']['id'],
					attributes['data']['name'],
					attributes['data']['email'],
					attributes['data']['image_url'],
					nil, response)
		end

		#
		#
		#
		def self.create(name, email, password)
			query = Faraday.new(url: "#{API_URL}/users/") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.post do |req|
				req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
				req.body = {
					email: email,
					name: name,
					password: password
				}.to_json
			end

			# check for return code
			attributes = JSON.parse(response.body)

			#return the newly created user
			new(attributes['data']['id'], attributes['data']['name'], attributes['data']['email'], nil, nil, response)
		end

		#
		#
		#
		def self.authenticate(email, password)
			query = Faraday.new(url: "#{API_URL}/users/authenticate") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.post do |req|
				req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
				req.body = {
					email: email,
					password: password
				}.to_json
			end

			# check for return code
			attributes = JSON.parse(response.body)

			#return the newly authenticated user
			new(attributes['data']['user']['id'],
					attributes['data']['user']['name'],
					attributes['data']['user']['email'],
					nil,
					attributes['data']['token'],
					response)
		end

	end
end
