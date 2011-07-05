module PayPal
  module Recurring
    module Response
      class Base
        attr_accessor :response

        def self.mapping(options = {})
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

        mapping(
          :token           => :TOKEN,
          :ack             => :ACK,
          :version         => :VERSION,
          :build           => :BUILD,
          :correlaction_id => :CORRELATIONID,
          :requested_at    => :TIMESTAMP
        )

        def initialize(response = nil)
          @response = response
        end

        def params
          @params ||= CGI.parse(response.body).inject({}) do |buffer, (name, value)|
            buffer.merge(name.to_sym => value.first)
          end
        end

        def errors
          @errors ||= begin
            index = 0
            [].tap do |errors|
              while params[:"L_ERRORCODE#{index}"]
                errors << {
                  :code => params[:"L_ERRORCODE#{index}"],
                  :messages => [
                    params[:"L_SHORTMESSAGE#{index}"],
                    params[:"L_LONGMESSAGE#{index}"]
                  ]
                }

                index += 1
              end
            end
          end
        end

        def success?
          ack == "Success"
        end

        def valid?
          errors.empty? && success?
        end

        private
        def build_requested_at(stamp) # :nodoc:
          Time.parse(stamp)
        end
      end
    end
  end
end
