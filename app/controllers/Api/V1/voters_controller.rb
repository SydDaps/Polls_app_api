class Api::V1::VotersController < ApplicationController

    def create

        emails = params[:emails]


        render json: {
            success: true,
            code: 200,
            data: {
              messages: "Voters are being added",
              Organizer: response[:organizer]
            }
          }
    end
end
