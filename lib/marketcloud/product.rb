require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Product < Request

		def initialize(attributes)
			super

			# A bit of ad-hoc initializations for the product
			@meta = attributes['seo']['meta'] unless attributes['seo'].nil? #title #keywords #description
			@facebook = attributes['seo']['facebook'] unless attributes['seo'].nil? #title #description #image
			@weight ||= 1
			@depth 	||= 1
			@width 	||= 1
			@height ||= 1
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

		def self.plural
			"products"
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
