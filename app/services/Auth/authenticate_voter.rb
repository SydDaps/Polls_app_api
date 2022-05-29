module Auth
  class AuthenticateVoter < BaseService
    def initialize(params)
      @index_number = params[:index_number]
      @pass_key = params[:pass_key]
      @poll = params[:poll]
    end

    def call
      voter = @poll.voters.find_by_index_number(@index_number)

      raise Exceptions::NotUniqueRecord
      .message("The index number #{@index_number} is not registered with this poll.") unless voter

      pass_hash = BCrypt::Password.new(voter.pass_key)

      unless pass_hash == @pass_key

        raise Exceptions::NotUniqueRecord.message("Invalid Pass Key")

      end


      {
        user: voter,
        access_token: JWT::JsonWebToken.encode({voter_id: voter.id}),
        poll: PollSerializer.new( @poll ).serialize
      }

    end
  end
end