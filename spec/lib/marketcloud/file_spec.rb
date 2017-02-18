require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::File do
	let(:file_id) { 129677 }

	describe 'a GET for a valid file' do

		let(:file) { VCR.use_cassette('file') { Marketcloud::File.find(file_id) }}

		it 'should return a valid file object' do
			expect(file).not_to be_nil
		end

		it 'answers to find with a valid file' do
		  expect(file.name).to eq "107224_0000165407723jpeg"
		end

	end

	# This test case does not work TODO
	# describe 'a POST to upload a file' do
	#
	# 	f = StringIO.new("Let us test some data", 'r')
	#
	# 	new_file = VCR.use_cassette('file_create') {
	# 			Marketcloud::File.create("file", "name", f, "A file description", "file-name")
	# 		}
	#
	# 	after(:all) { f.close }
	#
	# 	it 'should return 200' do
	# 		expect(new_file).not_to be_nil
	# 	end
	#
	# 	it 'returns a valid file' do
	# 		expect(new_file.name).to eq "file"
	# 	end
	#
	# end

end
