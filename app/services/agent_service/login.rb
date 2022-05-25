module AgentService
  class Login < BaseService
    def initialize(params)
      @email = params[:email]
      @password = params[:password]
      @poll = params[:poll]
    end

    def call
      agent = @poll.agents.find_by(email: @email)
      raise Exceptions::NotUniqueRecord
      .message("The agent email #{@email} is not registered with this poll.") unless agent

      unless agent.password_digest
        raise Exceptions::NotUniqueRecord.message("Agent password not set.")
      end

      unless agent.authenticate(@password)
        raise Exceptions::NotUniqueRecord.message("Invalid password.")
      end

      {
        token: JWT::JsonWebToken.encode({agent_id: agent.id}),
        data: AgentSerializer.new( agent ).serialize
      }
    end
  end
end