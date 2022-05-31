module Auth
    class AuthorizeRequest < BaseService
        def initialize(headers = {})
          @headers = headers
        end

        def call
            organizer
        end

        private

        def organizer
            if decode_auth_token
                if decode_auth_token[:organizer_id]
                    @user = Organizer.find(decode_auth_token[:organizer_id])
                elsif decode_auth_token[:voter_id]
                    @user = Voter.find(decode_auth_token[:voter_id])
                elsif decode_auth_token[:agent_id]
                    @user = Agent.find(decode_auth_token[:agent_id])
                end
            end
            raise Exceptions::UnauthorizedOperation.message("User Not found") unless @user

            @user
        end

        def decode_auth_token
           @decoded_token = JWT::JsonWebToken.decode(http_auth_header)
           raise Exceptions::ExpiredToken.message("Session expired.") unless @decoded_token
           @decoded_token
        end

        def http_auth_header
            if @headers['HTTP_AUTHORIZATION'].present?
                return @headers['HTTP_AUTHORIZATION'].split(' ').last
            end

            raise Exceptions::UnauthorizedOperation.message("Missing Token")
        end

    end
end