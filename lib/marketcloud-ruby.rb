require_relative 'marketcloud/address'
require_relative 'marketcloud/authentication'
require_relative 'marketcloud/braintree'
require_relative 'marketcloud/cart'
require_relative 'marketcloud/category'
require_relative 'marketcloud/configuration'
require_relative 'marketcloud/coupon'
require_relative 'marketcloud/order'
require_relative 'marketcloud/payment'
require_relative 'marketcloud/product'
require_relative 'marketcloud/shipping'
require_relative 'marketcloud/user'


API_URL = "http://api.marketcloud.it/v0"

module Marketcloud
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Marketcloud::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
