require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Category do

	describe 'a GET on a valid category' do
		let(:category) { VCR.use_cassette('category_ok') { Marketcloud::Category.find(104429) }}

		it 'should return 200' do
			expect(category.response.status).to eq 200
		end

		it 'answers to find with a valid category' do
		  expect(category.name).to eq "Per impastare"
		end
	end

	describe 'a GET on an invalid url for a category' do
		let(:category) { VCR.use_cassette('category_ko') { Marketcloud::Category.find(-1) }}

		it 'should return 400' do
			expect(category.response.status).to eq 400
		end
	end

	describe 'a GET on an invalid category' do
		let(:category) { VCR.use_cassette('category_no') { Marketcloud::Category.find(1) }}

		it 'should return 404' do
			expect(category.response.status).to eq 404
		end
	end
end
