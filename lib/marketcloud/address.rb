require_relative 'request'
require 'faraday'
require 'json'

module Marketcloud
	class Address < Request

		# Update the fields of the address
		# @param attributes a hash of attributes to update
		# @return true
		def update_fields(attributes)
			attributes.each do |attr_k, attr_v|
				self.send("#{attr_k}=", attr_v)
			end

			true
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

		# CLASS METHODS

		def self.cache_me?
			false
		end

		def self.plural
			"addresses"
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

		# Find an address by ID and checks it belongs to the user
		# @param id [Integer] the address ID
		# @param user_id [Integer] the user ID
		# @return an Address or nil
		def self.find_and_check_user(id, user_id)
			address = perform_request api_url("addresses/#{id}"), :get, nil, true

			if address
				addr = new address['data']
				if addr.user_id != user_id
					raise Marketcloud::AddressNotFound.new("Address #{addr.id} not belonging to user #{user_id}")
				end
				addr
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

		# Delete an address
		# @param address_ID [Integer] the address to be deleted
		# @return true in case of success
		def self.delete(id)
			success = perform_request api_url("addresses/#{id}", {}), :delete, nil, true

			if success
				true
			else
				false
			end
		end
	end
end
