require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Address < Request
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
			true
		end

		# Find an address by ID
		# @param id [Integer] the ID of the address
		# @return an Address or nil
		def self.find(id)
			address = perform_request api_url("addresses/#{id}"), :get, nil, true

			if address
				new address['data']
			else
				nil
			end
		end

		# Find all the addresses belonging to a user
		# @param user_id [Integer] the user ID
		# @return an array of Addresses or nil
		def self.find_by_user(user_id)
			addresses = perform_request api_url("addresses", { user_id: user_id }), :get, nil, true

			if addresses
				addresses['data'].map { |a| new(a) }
			else
				nil
			end
		end


		# Create a new address
		# @param address [Address] the new address
		# @return the newly created address
		def self.create(address)
			address = perform_request api_url("addresses", {}), :post, address, true

			if address
				new address['data']
			else
				nil
			end
		end

		# Updates the current address (! modifies object!)
		# @param address [Address] the updated addresss
		# @return true for success, false otherwise
		def update!(address)
			address = Address.perform_request Address.api_url("addresses/#{self.id}", {}), :put, address, true

			if address
				update_fields(address['data'])
			else
				false
			end
		end
	end
end
