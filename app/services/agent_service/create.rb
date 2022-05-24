module AgentService
  class Create < BaseService

    def initialize(agent_params)
      @poll = agent_params[:poll]
      @name = agent_params[:name]
      @email = agent_params[:email]
      @phone_number = agent_params[:phone_number]
    end

    def call
      agent = @poll.agents.find_by(email: @email)
      if agent
        raise Exceptions::NotUniqueRecord.message("Agent with email #{@email} already added")
      end

      agent = @poll.agents.create!(
        name: @name,
        email: @email
      )
    end
  end
end