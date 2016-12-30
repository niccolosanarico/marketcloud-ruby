require 'faraday'
require 'json'

module Marketcloud
	class User
		attr_accessor :name, :id, :email, :image_url, :token

		# INSTANCE METHODS

		#
		#
		#
		def initialize(attributes)
			if !attributes.nil?
				@id = attributes['id']
				@name = attributes['name']
				@email = attributes['email']
				@token = attributes['token']
				@image_url = attributes['image_url']
			end
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

			if response.status != 200
				return nil
			end

      attributes = JSON.parse(response.body)

			#return a user
			new(attributes['data'])
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

			if response.status != 200
				return nil
			end

      attributes = JSON.parse(response.body)

			#return a user - it is an array, so get the first one because of email uniqueness
			new(attributes['data'].first)
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

			if response.status == 400 && attributes["errors"].select { |e| e["type"] == "EmailAddressExists"}.length >= 1
				raise ExistingUserError
			end

			if response.status != 200
				return nil
			end

			#return the newly created user
			new(attributes['data'])
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

			if response.status != 200
				return nil
			end

			# check for return code
			attributes = JSON.parse(response.body)

			#return the newly authenticated user
			self.token = attributes['data']['token']
		end

	end
end
