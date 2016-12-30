require 'faraday'
require 'json'

module Marketcloud
	class Order
		attr_accessor :id,
									:cart_id,
									:status,
									:shipping_address_id,
									:billing_address_id,
									:shipping_id,
									:user_id,
									:store_id,
									:response

		#
		#
		#
		def initialize(attributes, response)
			@id = attributes['id']
			@user_id = attributes['user_id']
			@status = attributes['status']
			@shipping_address_id = attributes['shipping_address_id']
			@billing_address_id = attributes['billing_address_id']
			@shipping_id = attributes['shipping_id']
			@user_id = attributes['user_id']
			@store_id = attributes['store_id']
			@response = response
		end


		#
		#
		#
		def self.find(id)
      query = Faraday.new(url: "#{API_URL}/orders/#{id}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
			end

      attributes = JSON.parse(response.body)

			#return a order
			new(attributes['data'], response)
    end

		#
		#
		#
		def self.find_by_user(user_id)
      query = Faraday.new(url: "#{API_URL}/orders?user_id=#{user_id}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
			end

      orders = JSON.parse(response.body)

			#return a order
			orders['data'].map { |o| new(o, response) }
    end

		#
		#
		#
		def self.create(user_id, cart_id, shipping_address_id, billing_address_id, shipping_id)
			query = Faraday.new(url: "#{API_URL}/orders") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.post do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
				req.body = {
					cart_id: cart_id,
					user_id: user_id,
					shipping_address_id: shipping_address_id,
					billing_address_id: billing_address_id,
					shipping_id: shipping_id
				}.to_json
			end

      attributes = JSON.parse(response.body)

			if response.status != 200
        raise NotFound.new(attributes) if response.status == 404
				raise Anauthorized.new(attributes) if response.status == 401
        raise BadRequest.new(attributes) if response.status == 400
			end

			#return a order
			new(attributes['data'], response)
		end
	end
end
