require "bundler"
Bundler.setup(:default, :development)
Bundler.require

require "paypal-recurring"
require "vcr"

VCR.config do |config|
  config.cassette_library_dir = File.dirname(__FILE__) + "/fixtures"
  config.stub_with :fakeweb
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros

  config.before do
    PayPal::Recurring.configure do |config|
      config.sandbox = true
      config.username = "seller_1308793919_biz_api1.simplesideias.com.br"
      config.password = "1308793931"
      config.signature = "AFcWxV21C7fd0v3bYYYRCpSSRl31AzaB6TzXx5amObyEghjU13.0av2Y"
      config.seller_id = "GSZCRUB62BL5L"
      config.email = "seller_1308793919_biz_api1.simplesideias.com.br"
    end
  end
end
