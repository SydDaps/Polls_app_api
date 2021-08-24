class Api::V1::TokensController < ApplicationController


    def create
        response = Auth::AuthenticateOrganizer.call(params)
      
        render json: {
          success: true,
          code: 200,
          data: response
        }
      end
end
