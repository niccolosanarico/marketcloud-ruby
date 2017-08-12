require_relative 'request'
require 'faraday'
require 'json'
require 'base64'

module Marketcloud
	class File < Request

		def self.plural
			"files"
		end

		# Create a new file in the Marketcloud CDN
		# @param name a human friendly name
		# @param filename a filename
		# @param file_url a URL to a file
		# @param description the description of the file
		# @param slug a URL-friendly slug
		# @return a file
		def self.create(name, filename, file_url, description, slug, mime = "image/jpeg")
			file = ::File.open(file_url)
			new_file = perform_request(api_url(self.plural, {}), :post,
						{
							name: name,
							filename: filename,
							file: Base64.encode64(file.read),
              mime_type: mime,
							description: description,
							slug: slug
						}, true)

			if new_file
				new new_file['data']
			else
				nil
			end
		end

	end
end
