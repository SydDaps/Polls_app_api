class Api::V1::TokensController < ApplicationController
  skip_before_action :authenticate_request

  def create
      response = Auth::AuthenticateOrganizer.call(params)
    
      render json: {
        success: true,
        code: 200,
        data: response
      }
    end
end
