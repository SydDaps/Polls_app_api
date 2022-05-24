class Api::V1::AgentsController < ApplicationController
  skip_before_action :authenticate_request, :only => [:login, :reset_password]

  #send email to voter
  def create
    response = AgentService::Create.call(params.merge(poll: current_poll))
    data = AgentSerializer.new( response ).serialize
    render json: {
      success: true,
      code: 200,
      data: data
    }
  end

  #get all agents belonging to poll
  def index
    render json: {
      success: true,
      code: 200,
      data: AgentSerializer.new( current_poll.agents.all ).serialize
    }
  end

  #reset password
  def reset_token
    response = AgentService::SendResetToken.call(params.merge(poll: current_poll))
    render json: {
      success: true,
      code: 200,
      data: response
    }
  end

  def reset_password
    response = GeneralUserService::ResetPassword.call(params.merge(poll: current_poll))
    render json: {
      success: true,
      code: 200,
      data: response
    }
  end
end
