class Api::V1::UsersController < ApplicationController

  skip_before_action :authenticate_request

  def reset_token
    response = GeneralUserService::SendResetToken.call(params)
    render json: {
      success: true,
      code: 200,
      data: response
    }
  end

  def reset_password
    response = GeneralUserService::ResetPassword.call(params)
    render json: {
      success: true,
      code: 200,
      data: response
    }
  end
end
