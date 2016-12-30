require 'faraday'
require 'json'

module Marketcloud
	class Address
		attr_accessor :id, :full_name, :user_id, :email, :country, :state, :city, :address1,
									:address2, :postal_code, :phone_number, :alternate_phone_number,
									:vat

		def initialize(attributes)
			@id = attributes['id']
			@full_name = attributes['full_name']
			@user_id = attributes['user_id']
			@email = attributes['email']
			@country = attributes['country']
			@state = attributes['state']
			@city = attributes['city']
			@address1 = attributes['address1']
			@address2 = attributes['address2']
			@postal_code = attributes['postal_code']
			@phone_number = attributes['phone_number']
			@alternate_phone_number = attributes['alternate_phone_number']
			@vat = attributes['vat']
		end

		def update_fields(attributes)
			self.id = attributes['id']
			self.full_name = attributes['full_name']
			self.user_id = attributes['user_id']
			self.email = attributes['email']
			self.country = attributes['country']
			self.state = attributes['state']
			self.city = attributes['city']
			self.address1 = attributes['address1']
			self.address2 = attributes['address2']
			self.postal_code = attributes['postal_code']
			self.phone_number = attributes['phone_number']
			self.alternate_phone_number = attributes['alternate_phone_number']
			self.vat = attributes['vat']
		end

		#
		#
		#
		def self.find(id)
      query = Faraday.new(url: "#{API_URL}/addresses/#{id}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				# faraday.response :logger                  # log requests to STDOUT
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
			end

      attributes = JSON.parse(response.body)

			if response.status != 200
				Marketcloud.logger.error(response.body)
				return nil
			end

			#return a product
			new(attributes['data'])
    end

		#
		#
		#
		def self.find_by_user(user_id)
			query = Faraday.new(url: "#{API_URL}/addresses?user_id#{user_id}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				# faraday.response :logger                  # log requests to STDOUT
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.get do |req|
			  req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
			end

      addresses = JSON.parse(response.body)

			if response.status != 200
				Marketcloud.logger.error(response.body)
				return nil
			end

			#return an array of addresses associated with this user
			addresses['data'].map { |a| new(a) }
    end


		#
		#
		#
		def self.create(address)
			query = Faraday.new(url: "#{API_URL}/addresses") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				# faraday.response :logger                  # log requests to STDOUT
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.post do |req|
				req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
				req.body = address.to_json
			end

			attributes = JSON.parse(response.body)

			if response.status != 200
				Marketcloud.logger.error(response.body)
				return nil
			end

			#return an address
			new(attributes['data'])
		end

		#
		#
		#
		def update!(address)
			query = Faraday.new(url: "#{API_URL}/addresses/#{self.id}") do |faraday|
				faraday.request  :url_encoded             # form-encode POST params
				# faraday.response :logger                  # log requests to STDOUT
				faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
			end

			auth = Marketcloud::Authentication.get_token()

			response = query.put do |req|
				req.headers['Content-Type'] = 'application/json'
				req.headers['Authorization'] = "#{Marketcloud.configuration.public_key}:#{auth.token}"
				req.body = address.to_json
			end

			attributes = JSON.parse(response.body)

			if response.status != 200
				Marketcloud.logger.error(response.body)
				return nil
			end
			#update the fields
			update_fields(attributes['data'])
		end
	end
end
