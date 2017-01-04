require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Application do
	describe 'a GET for the application' do

		let(:application) { VCR.use_cassette('application') { Marketcloud::Application.find() }}

		it 'should return an application' do
			expect(application).not_to be_nil
		end

		it 'answers to find with a valid application' do
		  expect(application.name).to eq "Coalca Shop Test"
		end

	end
end
