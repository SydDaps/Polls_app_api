
class Api::V1::OrganizersController < ApplicationController
  skip_before_action :authenticate_request

  def create
      response = OrganizerService::Create.call(params)

      render json: {
          success: true,
          code: 200,
          data: {
            token: response[:token],
            Organizer: response[:organizer]
          }
        }
  end
end
