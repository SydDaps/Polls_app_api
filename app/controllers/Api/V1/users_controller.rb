class Api::V1::UsersController < ApplicationController

  skip_before_action :authenticate_request, only: [:reset_token]

  def reset_token
    response = GeneralUserService::SendResetToken.call(params)
    render json: {
      success: true,
      code: 200,
      data: response
    }
  end

  def reset_password
    response = GeneralUserService::ResetPassword.call(params.merge(current_user: @current_user))
    render json: {
      success: true,
      code: 200,
      data: response
    }
  end
end
