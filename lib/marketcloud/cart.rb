require 'faraday'
require 'json'

module Marketcloud
	class Cart
		attr_accessor :id,
									:user_id,
									:items

		def initialize(attributes)
			@id = attributes['id']
			@user_id = attributes['user_id']
			@items = attributes['items']
		end

		# INSTANCE METHODS

		#
		#
		#
		def update(items)
			query = Faraday.new(url: "#{API_URL}/carts/#{self.id}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.patch do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
				req.body = {
					op: "update",
					items: items
				}.to_json
			end

      attributes = JSON.parse(response.body)

			if response.status != 200

				Marketcloud.logger.error = response.body

				return nil
			end

			#return an updated cart
			Cart.new(attributes["data"])
		end


		#
		# Add merges the quantity of existing products in the cart
		#
		def add(items)
			query = Faraday.new(url: "#{API_URL}/carts/#{self.id}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.patch do |req|
				req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
				req.body = {
					op: "add",
					items: items.map { |item| { product_id: item["product_id"], quantity: item["quantity"] } }
				}.to_json
			end

			attributes = JSON.parse(response.body)

			if response.status != 200

				Marketcloud.logger.error = response.body

				return nil
			end

			#added to the cart
			Cart.new(attributes["data"])
		end


		# CLASS METHODS

		#
		# Find a cart by ID
		#
		def self.find(id)
      query = Faraday.new(url: "#{API_URL}/carts/#{id}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				# faraday.response :logger                  # log requests to STDOUT
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
			end

			# puts response.body
      attributes = JSON.parse(response.body)

			if response.status != 200
				return nil
			end

			#return a cart
			new(attributes['data'])
  	end

		#
		# Find a cart by user id. It might be more than one
		#
		def self.find_by_user(user_id)
      query = Faraday.new(url: "#{API_URL}/carts?user_id=#{user_id}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				# faraday.response :logger                  # log requests to STDOUT
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
			end

			# puts response.body
      carts = JSON.parse(response.body)

			if response.status != 200
				return nil
			end

			carts['data'].map { |c| new(c) }
    end


		#
		# Create a cart without products in it
		#
		def self.create(user_id=nil)
			query = Faraday.new(url: "#{API_URL}/carts") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				# faraday.response :logger                  # log requests to STDOUT
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.post do |req|
			  req.headers['content-type'] = 'application/json'
        req.headers['accept'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
        req.body = {
          user_id: user_id,
					items: []
        }.to_json
			end

			attributes = JSON.parse(response.body)

			if response.status != 200
				return nil
			end

			#return a newly created cart
			new(attributes['data'])
		end
	end
end
