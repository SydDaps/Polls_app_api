module Auth
    class AuthenticateOrganizer < BaseService
        def initialize(auth_fields)
          @email = auth_fields[:email]
          @password = auth_fields[:password]
        end

        def call
          organizer = Organizer.find_by_email(@email)&.authenticate(@password)

          raise Exceptions::UnauthorizedOperation.message("Check Email or password") unless organizer


          {
            token: JWT::JsonWebToken.encode({organizer_id: organizer.id}),
            organizer: organizer
          }
        end

        private

        def organizer
            organizer = Organizer.find_by_email(@email)
            return organizer if organizer && organizer.authenticate(@password)
            raise Exceptions::UnauthorizedOperation.message("Check Email or password")
        end

    end
end