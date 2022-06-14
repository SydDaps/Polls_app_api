module Auth
  class AuthenticateVoter < BaseService
    def initialize(params)
      @email = params[:email]
      @password = params[:password]
    end

    def call
      voter = Voter.find_by(email: @email)&.authenticate(@password)

      raise Exceptions::NotUniqueRecord
      .message("Check email or password") unless voter

      {
        token: JWT::JsonWebToken.encode({voter_id: voter.id}),
        voter: VoterSerializer.new( voter ).serialize
      }

    end
  end
end