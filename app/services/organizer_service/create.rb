module OrganizerService
    class Create < BaseService
        def initialize(params)
            @name = params[:name]
            @email = params[:email]
            @password = params[:password]
            @password_confirmation = params[:password_confirmation]
            
        end

        def call
            organizer = Organizer.find_by_email(@email)
            raise Exceptions::NotUniqueRecord.message("#{@email} already has an account") if organizer
            organizer = Organizer.create!(
                name: @name,
                password: @password,
                password_confirmation: @password_confirmation,
                email: @email
            )

            {
                token: JWT::JsonWebToken.encode({organizer_id: organizer.id}),
                organizer: organizer
            }
        end
    end
end