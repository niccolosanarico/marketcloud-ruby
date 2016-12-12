require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Product do
	let(:prod) { FactoryGirl.build(:product) }

	describe 'is valid' do
		it 'has a name' do
			expect(prod.name).not_to be_nil
		end
	end
end  
