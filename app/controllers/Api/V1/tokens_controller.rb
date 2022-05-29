class Api::V1::TokensController < ApplicationController
  skip_before_action :authenticate_request

  def create

      case params[:login_type]
      when "organizer"
        response = Auth::AuthenticateOrganizer.call(params)
      when "agent"
        response = Auth::AuthenticateAgent.call(params)
      when "voter"
        response = Auth::AuthenticateVoter.call(params.merge(poll: current_poll))
      end

      render json: {
        success: true,
        code: 200,
        data: response
      }
    end
end
