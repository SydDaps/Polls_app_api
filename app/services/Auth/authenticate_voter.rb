module Auth
  class AuthenticateVoter < BaseService
    def initialize(params)
      @email = params[:email].downcase!
      @password = params[:password]
      @phone_number = params[:phone_number]
    end

    def call
      if @email
        voter = Voter.find_by(email: @email)&.authenticate(@password)
      elsif @phone_number
        parse_phone_number
        voter = Voter.find_by(phone_number: @phone_number)&.authenticate(@password)
      end

      raise Exceptions::NotUniqueRecord
      .message("Check email/phone number or password") unless voter

      {
        token: JWT::JsonWebToken.encode({voter_id: voter.id}),
        voter: VoterSerializer.new( voter ).serialize
      }

    end

    def parse_phone_number
      if @phone_number
        phone_valid = Phonelib.valid?(@phone_number)
        phone = Phonelib.parse(@phone_number)

        unless phone.country == "GH" && phone_valid
          raise ActiveRecord::RecordNotFound
          .message("Phone number is not valid")
        end

        @phone_number = phone.e164
      end
    end
  end
end