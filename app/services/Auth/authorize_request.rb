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
            @organizer = Organizer.find(decode_auth_token[:organizer_id]) if decode_auth_token
            raise Exceptions::UnauthorizedOperation.message("User Not found") unless @organizer
            @organizer
        end

        def decode_auth_token
           @decoded_token = JWT::JsonWebToken.decode(http_auth_header)
           raise Exceptions::ExpiredToken.message("Session Expired login again") unless @decoded_token
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