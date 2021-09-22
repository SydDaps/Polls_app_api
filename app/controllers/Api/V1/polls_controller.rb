class Api::V1::PollsController < ApplicationController

    def index
        render json: {
            success: true,
            code: 200,
            data: PollSerializer.new( @current_organizer.polls ).serialize
        }

    end

    def create
        response = PollService::Create.call(params.merge(organizer: @current_organizer))

        render json: {
            success: true,
            code: 200,
            data: PollSerializer.new( response ).serialize
        }
    end

    def show
        response = Poll.find(params[:id])

        render json: {
            success: true,
            code: 200,
            data: PollSerializer.new( response ).serialize
        }
    end
end
