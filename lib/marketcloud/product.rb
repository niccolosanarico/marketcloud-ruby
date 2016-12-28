require 'faraday'
require 'json'

module Marketcloud
	class Product
		attr_accessor :name, :id, :sku, :description,
									:category_id, :brand_id, :price,
									:response, :config

		def initialize(attributes, response, config = Configuration.new)
			@id = attributes['id']
			@name = attributes['name']
			@sku = attributes['sku']
			@description = attributes['description']
			@category_id = attributes['category_id']
			@brand_id = attributes['brand_id']
			@price = attributes['price']
			@response = response
			@config = config
		end

		#
		#
		#
		def self.find(id)
      query = Faraday.new(url: "#{API_URL}/products/#{id}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = Marketcloud.configuration.public_key
			end

      attributes = JSON.parse(response.body)

			#return a product
			new(attributes['data'], response)
    end

		#
		#
		#
		def self.find_by_category(cat_id, published=true)
      query = Faraday.new(url: "#{API_URL}/products?category_id=#{cat_id}&published=#{published}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = Marketcloud.configuration.public_key
			end

			products = JSON.parse(response.body)

			#return a list of products
			products['data'].map { |p| new(p, response) }
    end


		#
		#
		#
		def self.all(published=true)
			query = Faraday.new(url: "#{API_URL}/products?published=#{published}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
			end

      products = JSON.parse(response.body)

			#return a list of products
			products['data'].map { |p| new(p, response) }

		end

	end
end
