module JWT
    class JsonWebToken
        def self.encode(payload, exp =  2.days.from_now)
            payload[:exp] = exp.to_i
            JWT.encode(payload, ENV['POLLS_API_SECRETE'])
        end

        def self.decode(token)
            begin
                body = JWT.decode(token, ENV['POLLS_API_SECRETE']).first
                HashWithIndifferentAccess.new body
            rescue 
                return
            end
        end
    end
end