class Api::V1::PollsController < ApplicationController

    def create
        response = PollService::Create.call(params.merge(organizer: @current_organizer))

        render json: {
            success: true,
            code: 200,
            data: response
        }
    end
end
