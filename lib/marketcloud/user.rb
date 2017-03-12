require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class User < Request

		# CLASS METHODS

		# Do not cache objects from this class
		def self.cache_me?
      false
		end

		def self.plural
			"users"
		end


		# Find a user by email
		# @param email [String] the email of the user
		# @return a User or nil
		def self.find_by_email(email)
			user = perform_request api_url("users", { email: email }), :get, nil, true

			if !user['data'].empty?
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

		# INSTANCE METHODS

		# Authenticate the current user
		# @param password [Integer] the password
		# @return true in case of success
		def authenticate!(password)
			auth = User.perform_request User.api_url("users/authenticate", {}), :post,
				{ email: self.email,
					password: password }, true

			# A bit of additional code here to keep the initialization tidy
			if auth
				if(self.respond_to? :token=)
					self.token = auth['data']['token']
				else
					self.class.send(:define_method, "token=") { |value| @token=value }
					self.class.send(:define_method, "token") { @token }
					self.token = auth['data']['token']
				end
				true
			else
				false
			end
		end

		# Updates a user. It modifies the caller!
		# Beware: here be dragons. If you add a custom attribute, this method will try
		# to assign a value to a non existing instance variable
		# Create a sub class and add all the required custom attributes to it.
		# @param id [String] the id of the user
		# @param fields [Hash] a hash containing the fields to be updated
		# @return true in case of success
		def update!(options: {})
			user = User.perform_request User.api_url("users/#{id}"), :put, options, true

			if user
				options.each do |key, value|
					self.send("#{key}=", user['data']["#{key}"])
				end
			else
				nil
			end
		end

	end
end
