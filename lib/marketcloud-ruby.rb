require_relative 'marketcloud/address'
require_relative 'marketcloud/application'
require_relative 'marketcloud/authentication'
require_relative 'marketcloud/braintree'
require_relative 'marketcloud/brand'
require_relative 'marketcloud/cart'
require_relative 'marketcloud/category'
require_relative 'marketcloud/collection'
require_relative 'marketcloud/configuration'
require_relative 'marketcloud/coupon'
require_relative 'marketcloud/handle_errors'
require_relative 'marketcloud/order'
require_relative 'marketcloud/payment'
require_relative 'marketcloud/product'
require_relative 'marketcloud/promotion'
require_relative 'marketcloud/request'
require_relative 'marketcloud/shipping'
require_relative 'marketcloud/user'
require_relative 'marketcloud/variant'
require 'logger'


API_URL = "http://api.marketcloud.it/v0"

module Marketcloud
  class NotFound < StandardError; end
  class BadRequest < StandardError; end
  class Anauthorized < StandardError; end
  class InternalServerError < StandardError; end
  class ExistingUserError < StandardError; end
  class BraintreeProcessorDeclinedError < StandardError; end
  class AddressNotFound < StandardError; end

  class << self
    attr_accessor :configuration
    attr_writer :logger

    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = self.name
      end
    end
  end

  def self.configuration
    @configuration ||= Marketcloud::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
