module PayPal
  module Recurring
    module Utils
      def convert_to_time(string)
        DateTime.strptime(string, "%H:%M:%S %b %e, %Y %Z").new_offset(0)
      end

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
