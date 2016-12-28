require_relative '../../../spec/spec_helper'

RSpec.describe Marketcloud::Configuration do
  describe "public_key" do
    it "defaults to nil" do
      expect(Marketcloud::Configuration.new.public_key).to eq nil
    end
  end

  describe "#public_key=" do
    it "can set a value" do
      config = Marketcloud::Configuration.new
      config.public_key = "nil"
      expect(config.public_key).to eq "nil"
    end
  end

  describe "private_key" do
    it "defaults to nil" do
      expect(Marketcloud::Configuration.new.private_key).to eq nil
    end
  end

  describe "#private_key=" do
    it "can set a value" do
      config = Marketcloud::Configuration.new
      config.private_key = "nil"
      expect(config.private_key).to eq "nil"
    end
  end
end
