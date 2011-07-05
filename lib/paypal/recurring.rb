require "net/https"
require "cgi"
require "uri"
require "ostruct"
require "time"

module PayPal
  module Recurring
    autoload :Base, "paypal/recurring/base"
    autoload :Notification, "paypal/recurring/notification"
    autoload :Request, "paypal/recurring/request"
    autoload :Response, "paypal/recurring/response"
    autoload :Version, "paypal/recurring/version"
    autoload :Utils, "paypal/recurring/utils"

    ENDPOINTS = {
       :sandbox => {
         :api  => "https://api-3t.sandbox.paypal.com/nvp",
         :site => "https://www.sandbox.paypal.com/cgi-bin/webscr"
       },
       :production => {
         :api  => "https://api-3t.paypal.com/nvp",
         :site => "https://www.paypal.com/cgi-bin/webscr"
       }
    }

    class << self
      # Define if requests should be made to PayPal's
      # sandbox environment. This is specially useful when running
      # on development or test mode.
      #
      #   PayPal::Recurring.sandbox = true
      #
      attr_accessor :sandbox

      # Set PayPal's API username.
      #
      attr_accessor :username

      # Set PayPal's API password.
      #
      attr_accessor :password

      # Set PayPal's API signature.
      #
      attr_accessor :signature

      # Set seller id. Will be used to verify IPN.
      #
      #
      attr_accessor :seller_id

      # The seller e-mail. Will be used to verify IPN.
      #
      attr_accessor :email
    end

    # Just a shortcut for <tt>PayPal::Recurring::Base.new</tt>.
    #
    def self.new(options = {})
      Base.new(options)
    end

    # Configure PayPal::Recurring options.
    #
    #   PayPal::Recurring.configure do |config|
    #     config.sandbox = true
    #   end
    #
    def self.configure(&block)
      yield PayPal::Recurring
    end

    # Detect if sandbox mode is enabled.
    #
    def self.sandbox?
      sandbox == true
    end

    # Return a name for current environment mode (sandbox or production).
    #
    def self.environment
      sandbox? ? :sandbox : :production
    end

    # Return URL endpoints for current environment.
    #
    def self.endpoints
      ENDPOINTS[environment]
    end

    # Return API endpoint based on current environment.
    #
    def self.api_endpoint
      endpoints[:api]
    end

    # Return PayPal's API version.
    #
    def self.api_version
      "72.0"
    end

    # Return site endpoint based on current environment.
    #
    def self.site_endpoint
      endpoints[:site]
    end
  end
end
