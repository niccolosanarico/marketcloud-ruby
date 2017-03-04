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

	describe 'a POST to upload a file' do

		let(:new_file) { VCR.use_cassette('file_create') {
				Marketcloud::File.create("file", "name", "spec/fixtures/files/0500070.jpg", "A file description", "file-name")
			} }

		it 'should return 200' do
			expect(new_file).not_to be_nil
		end

		it 'returns a valid file' do
			expect(new_file.name).to eq "file"
		end

	end

end
