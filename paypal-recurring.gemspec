# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "paypal-recurring"

Gem::Specification.new do |s|
  s.name        = "paypal-recurring"
  s.version     = PayPal::Recurring::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nando Vieira"]
  s.email       = ["fnando.vieira@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/paypal-recurring"
  s.summary     = "PayPal Express Checkout API Client for recurring billing."
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 2.6"
  s.add_development_dependency "rake", "~> 0.8.7"
  s.add_development_dependency "vcr", "~> 1.10"
  s.add_development_dependency "fakeweb", "~> 1.3.0"
  s.add_development_dependency "ruby-debug19"
end
