require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::User do
	let(:user_id) { 107227 }

	describe 'a GET on a valid user' do
	  let(:user) { VCR.use_cassette('user') { Marketcloud::User.find(user_id) }}

		it 'should return 200' do
			expect(user.response.status).to eq 200
		end

		it 'answers to find with a valid user' do
		  expect(user.name).to eq "Pinco Pallo"
		end

	end

	describe 'a POST creating a new user' do
		let(:new_user) { VCR.use_cassette('user_new') { Marketcloud::User.create('prova', 'prova2@prova.it', 'provapw') }}

		it 'should return 200' do
			expect(new_user.response.status).to eq 200
		end

		it 'should return a valid user' do
			expect(new_user.name).to eq 'prova'
		end
	end

	describe 'a POST authenticating a user' do
		let(:auth_user) { VCR.use_cassette('user_authenticate') { Marketcloud::User.authenticate('prova2@prova.it', 'provapw') }}
		it 'should return 200' do
			expect(auth_user.response.status).to eq 200
		end

		it 'should return a valid user' do
			expect(auth_user.email).to eq 'prova2@prova.it'
		end

		it 'should return a token' do
			expect(auth_user.token).not_to be_nil
		end
	end
end
