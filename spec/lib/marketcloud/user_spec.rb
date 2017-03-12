require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::User do
	let(:user_id) { 107227 }
	let(:user_email) { "prova2@prova.it" }

	describe 'a GET on a valid user' do
	  let(:user) { VCR.use_cassette('user') { Marketcloud::User.find(user_id) }}

		it 'should return 200' do
			expect(user).not_to be_nil
		end

		it 'answers to find with a valid user' do
		  expect(user.name).to eq "Panco Pillowo1"
		end
	end

	context "A GET on a search by email" do
		describe 'on a valid user' do
		  let(:user) { VCR.use_cassette('user_by_email') { Marketcloud::User.find_by_email(user_email) }}

			it 'should return 200' do
				expect(user).not_to be_nil
			end

			it 'answers to find with a valid user' do
			  expect(user.name).to eq "prova"
			end
		end

		describe 'on an invalid user' do
		  let(:user) { VCR.use_cassette('user_by_email_invalid') { Marketcloud::User.find_by_email("not_a_valid@email.com") }}

			it 'should return nil' do
				expect(user).to be_nil
			end
		end
	end

	describe 'a POST creating a new user' do
		let(:new_user) { VCR.use_cassette('user_new') { Marketcloud::User.create('prova', 'prova3@prova.it', 'provapw') }}

		it 'should return 200' do
			expect(new_user).not_to be_nil
		end

		it 'should return a valid user' do
			expect(new_user.name).to eq 'prova'
		end
	end

	describe 'a POST creating a new user with existing email' do

		it 'should raise an expection' do
			expect { VCR.use_cassette('user_new_existing') { Marketcloud::User.create('prova', 'prova2@prova.it', 'provapw') } }.to raise_error(Marketcloud::ExistingUserError)
		end

	end

	describe 'a POST authenticating a user' do
		let(:user) { VCR.use_cassette('user_find_for_authentication') { Marketcloud::User.find_by_email('prova2@prova.it') }}
		let(:auth_user) { VCR.use_cassette('user_authenticate') {
			user.authenticate!('provapw')
			user
		}}
		it 'should return 200' do
			expect(auth_user).not_to be_nil
		end

		it 'should return a valid user' do
			expect(auth_user.email).to eq 'prova2@prova.it'
		end

		it 'should return a token' do
			expect(auth_user.token).not_to be_nil
		end
	end

	describe 'a PUT on a valid user to change a custom field' do
	  let(:user) {
			VCR.use_cassette('user_update') {
				the_user = Marketcloud::User.find(user_id)
				the_user.update!(options: {name: 'Panco Pillowo1'})
				the_user
			}}

		it 'should return 200' do
			expect(user).not_to be_nil
		end

		it 'answers to find with a valid user' do
		  expect(user.name).to eq "Panco Pillowo1"
		end
	end
end
