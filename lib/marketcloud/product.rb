require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Product < Request
		attr_accessor :name, :id, :sku, :description,
									:category_id, :brand_id,
									:price, :images, :meta,
									:has_variants, :variantsDefinition, :variants,
									:weight, :depth, :width, :height, :stock_status

		def initialize(attributes)
			@id = attributes['id']
			@name = attributes['name']
			@sku = attributes['sku']
			@description = attributes['description']
			@category_id = attributes['category_id']
			@brand_id = attributes['brand_id']
			@price = attributes['price']
			@images = attributes['images']
			@meta = attributes['seo']['meta'] unless attributes['seo'].nil? #title #keywords #description
			@weight = attributes['weight'] || 1
			@depth = attributes['depth'] || 1
			@width = attributes['width'] || 1
			@height = attributes['height'] || 1
			@stock_status = attributes['stock_status']
			@has_variants = attributes['has_variants']
			@variantsDefinition = attributes['variantsDefinition']
			if @has_variants
				@variants = Array.new
				if attributes['variants']
					attributes['variants'].each do |variant|
						@variants << Variant.new(variant, @variantsDefinition)
					end
				elsif attributes['variant'] # in this case there is only a variant, and this is the outcome of an order
					@variants << Variant.new(attributes['variant'], @variantsDefinition)
				end
			end
		end

		# Find a product by ID
		# @param id [Integer] the ID of the product
		# @return a Product or nil
		def self.find(id)
			product = perform_request api_url("products/#{id}")

			if product
				new product['data']
			else
				nil
			end
		end

		# Find all the products belonging to a category
		# @param cat_id [Integer] the category ID
		# @param published [Boolean] whether query only for published products, defaults to true
		# @return an array of Products or nil
		def self.find_by_category(cat_id, q: nil, page: 1, per_page: 20, price_gt: 0, price_lt: 10000000000000, published: true)
			query = {
				per_page: per_page,
				page: page,
				price_gt: price_gt,
				price_lt: price_lt,
				category_id: cat_id,
				published: published
			}
			query[:q] = q unless q.nil?

			products = perform_request(api_url("products",
																				query), :get, nil, false)

			if products
					products['data'].map { |p| new(p) }
			else
				nil
			end
		end

		# Return all the products
		# @param published [Boolean] whether query only for published products, defaults to true
		# @return an array of Products
		def self.all(q: nil, page: 1, per_page: 20, price_gt: 0, price_lt: 10000000000000, published: true)
			query = {
				per_page: per_page,
				page: page,
				price_gt: price_gt,
				price_lt: price_lt,
				published: published
			}
			query[:q] = q unless q.nil?
			products = perform_request(api_url("products",query), :get, nil, false)

			if products
				products['data'].map { |p| new(p) }
			else
				nil
			end
		end

		# returns how many products and how many pages there are
		# @param per_page [Integer] how many products per page
		# @return [count, pages]
		def self.count_and_pages(per_page: 20)
			products = perform_request(api_url("products", { per_page: per_page }), :get, nil, false)

			if products
				[products["count"], products["pages"]]
			else
				nil
			end
		end

	end
end
