require "bundler"
Bundler.setup(:default, :development)
Bundler.require

require "paypal-recurring"
require "vcr"
require "active_support/all"

VCR.configure do |config|
  config.cassette_library_dir = File.dirname(__FILE__) + "/fixtures"
  config.hook_into :fakeweb
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros

  config.before do
    PayPal::Recurring.configure do |config|
      config.sandbox = true
      config.username = "fnando.vieira+seller_api1.gmail.com"
      config.password = "PRTZZX6JDACB95SA"
      config.signature = "AJnjtLN0ozBP-BF2ZJrj5sfbmGAxAnf5tev1-MgK5Z8IASmtj-Fw.5pt"
      config.seller_id = "F2RM85WS56YX2"
      config.email = "fnando.vieira+seller.gmail.com"
    end
  end
end
