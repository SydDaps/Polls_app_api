module Auth
  class AuthenticateAgent < BaseService
    def initialize(params)
      @email = params[:email]
      @password = params[:password]
      @poll = params[:poll]
    end

    def call
      agent = Agent.find_by(email: @email)
      raise Exceptions::NotUniqueRecord
      .message("The agent email #{@email} is not registered.") unless agent

      unless agent.password_digest
        raise Exceptions::NotUniqueRecord.message("Agent password not set.")
      end

      unless agent.authenticate(@password)
        raise Exceptions::NotUniqueRecord.message("Invalid password.")
      end

      {
        token: JWT::JsonWebToken.encode({agent_id: agent.id}),
        agent: AgentSerializer.new( agent ).serialize
      }
    end
  end
end