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
		def initialize(attributes, response)
			if !attributes.nil?
				@id = attributes['id']
				@name = attributes['name']
				@email = attributes['email']
				@token = attributes['token']
				@image_url = attributes['image_url']
			end
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
			new(attributes['data'], response)
		end

		#
		#
		#
		def self.find_by_email(email)
      query = Faraday.new(url: "#{API_URL}/users?email=#{email}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
			end

      attributes = JSON.parse(response.body)

			#return a user - it is an array, so get the first one
			new(attributes['data'].first, response)
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
			new(attributes['data'], response)
		end

		#
		#
		#
		def authenticate!(password)
			query = Faraday.new(url: "#{API_URL}/users/authenticate") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.post do |req|
				req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
				req.body = {
					email: self.email,
					password: password
				}.to_json
			end

			# check for return code
			attributes = JSON.parse(response.body)

			#return the newly authenticated user
			self.token = attributes['data']['token']
			puts "THE TOKEN #{self.token}"
			self.response = response
		end

	end
end
