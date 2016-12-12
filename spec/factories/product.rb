require_relative "../../spec/spec_helper.rb"

FactoryGirl.define do
	factory :product, class: Marketcloud::Product do
		name "Frigorifero"
	end
end
