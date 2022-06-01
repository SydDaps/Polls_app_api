module AgentService
  class Create < BaseService

    def initialize(agent_params)
      @poll = agent_params[:poll]
      @name = agent_params[:name]
      @email = agent_params[:email]
      @phone_number = agent_params[:phone_number]
      @params = agent_params
    end

    def call
      validate_agent

      message = add_agent_to_poll

      data = AgentSerializer.new( @agent ).serialize
      {
        message: message,
        data: data
      }
    end

    def validate_agent
      @agent = @poll.agents.find_by(email: @email)

      if @agent
        raise Exceptions::NotUniqueRecord.message("Agent with email #{@email} already added to poll")
      end
    end

    def add_agent_to_poll
      @agent = Agent.find_by(email: @email)

      unless @agent
        @agent = Agent.create!(
          name: @name,
          email: @email
        )

        message_sent = ::GeneralUserService::SendResetToken.call(@params.merge(user_type: "agent"))
      end

      @poll.agents.push(@agent)
      @poll.save!


      message = "Agent added to poll. "
      message = message + message_sent[:message] if message_sent

      message
    end
  end
end