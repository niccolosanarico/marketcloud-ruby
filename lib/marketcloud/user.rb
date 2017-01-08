require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class User < Request
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


		# Check whether the user iis authenticated
		# @return true if authenticated
		def authenticated?
			return !self.token.nil?
		end


		# CLASS METHODS

		# Find a user by ID
		# @param id [Integer] the ID of the user
		# @return a User or nil
		def self.find(id)
			user = perform_request api_url("users/#{id}"), :get, nil, true

			if user
				new user['data']
			else
				nil
			end
		end

		# Find a user by email
		# @param email [String] the email of the user
		# @return a User or nil
		def self.find_by_email(email)
			user = perform_request api_url("users", { email: email }), :get, nil, true

			if user
				new user['data'].first
			else
				nil
			end
		end

		# Create a new user
		# @param name [Integer] the user name
		# @param email [Integer] the user email
		# @param password [Integer] the user password
		# @return the newly created user
		def self.create(name, email, password)
			user = perform_request api_url("users", {}), :post, { email: email, name: name, password: password }, true

			if user
				new user['data']
			else
				nil
			end

			# if response.status == 400 && attributes["errors"].select { |e| e["type"] == "EmailAddressExists"}.length >= 1
			# 	raise ExistingUserError
			# end
		end

		# Authenticate the current user
		# @param password [Integer] the password
		# @return true in case of success
		def authenticate!(password)
			auth = User.perform_request User.api_url("users/authenticate", {}), :post,
				{ email: self.email,
					password: password }, true

			if auth
				self.token = auth['data']['token']
				true
			else
				false
			end
		end

		# Updates a user
		# @param id [String] the id of the user
		# @param fields [Hash] a hash containing the fields to be updated
		# @return a User or nil
		def update(options: {})
			user = User.perform_request User.api_url("users/#{id}"), :put, options, true

			if user
				User.new user['data']
			else
				nil
			end
		end

	end
end
