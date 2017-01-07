require 'json'

module Marketcloud
  module HandleErrors
    def raise_exception(response_error, response_status)
      # raise NotFound.new(response.body) if response.status == 404
      raise Anauthorized.new(response_error) if response_status == 401

      if response_status == 400
        if response_error["type"] == "EmailAddressExists"
          raise ExistingUserError.new(response_error)

        elsif response_error["message"] == "Braintree transaction error. See object for more details."
          if response_error["Braintree"]
            if response_error["Braintree"]["transaction"] && response_error["Braintree"]["transaction"]["status"] == "processor_declined"
              raise BraintreeProcessorDeclinedError.new("Processor declined error for order #{response_error["Braintree"]["transaction"]["orderId"]}, code: #{response_error["Braintree"]["transaction"]["processorResponseCode"]}")
            end
          end
        # else
        #   raise BadRequest.new(response.body)
        end
      end
    end
  end
end
