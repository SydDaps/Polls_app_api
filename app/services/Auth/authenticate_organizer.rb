module Auth
    class AuthenticateOrganizer < BaseService
        def initialize(auth_fields)
          @email = auth_fields[:email]
          @password = auth_fields[:password]
        end

        def call
            if organizer
                {
                    token: JWT::JsonWebToken.encode({organizer: organizer.id}),
                    organizer: organizer
                }
                
            end
        end

        private

        def organizer
            organizer = Organizer.find_by_email(@email)
            return organizer if organizer && organizer.authenticate(@password)
            raise Exceptions::UnauthorizedOperation.message("Check Email or password")
        end

    end
end