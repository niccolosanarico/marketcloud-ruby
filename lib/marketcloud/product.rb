require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Product < Request

		attr_accessor :meta, :facebook, :weight, :height, :width, :depth, :has_variants, :variants

		def initialize(attributes)
			super

			# A bit of ad-hoc initializations for the product
			@meta = attributes['seo']['meta'] unless attributes['seo'].nil? #title #keywords #description
			@facebook = attributes['seo']['facebook'] unless attributes['seo'].nil? #title #description #image
			@weight ||= 1
			@depth 	||= 1
			@width 	||= 1
			@height ||= 1

			# if self.respond_to?(:has_variants) && self.has_variants
			if self.has_variants
				self.variants = Array.new
				if attributes['variants']
					attributes['variants'].each do |variant|
						self.variants << Variant.new(variant, self.variantsDefinition)
					end
				elsif attributes['variant'] # in this case there is only a variant, and this is the outcome of an order
					self.variants << Variant.new(attributes['variant'], self.variantsDefinition)
				end
			end
		end

		def self.plural
			"products"
		end

		# Find an object by ID - need to instantiate it here to call the right initializer
		# @param id [Integer] the ID of the object
		# @return an object or nil
		def self.find(id = nil)
			object = perform_request api_url("#{self.plural}/#{id}"), :get, nil, true

			if object
				new object['data']
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

		# Create a new product and returns it
		# @param product a hash with the product
		# @return a new product
		def self.create(product)
			prod = perform_request(api_url("products"), :post, product, true)

			if prod
				new(prod['data'])
			else
				nil
			end
		end
	end
end
