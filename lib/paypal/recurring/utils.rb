module PayPal
  module Recurring
    module Utils
      def mapping(options = {})
        options.each do |to, from|
          class_eval <<-RUBY
            def #{to}
              @#{to} ||= begin
                from = [#{from.inspect}].flatten
                name = from.find {|name| params[name]}
                value = nil
                value = params[name] if name
                value = send("build_#{to}", value) if respond_to?("build_#{to}", true)
                value
              end
            end
          RUBY
        end
      end
    end
  end
end
