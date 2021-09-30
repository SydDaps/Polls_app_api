class Api::V1::PollsController < ApplicationController

    def index
        
        render json: {
            success: true,
            code: 200,
            data: PollSerializer.new( @current_user.polls.all.order(created_at: :desc) ).serialize
        }

    end

    def create
        response = PollService::Create.call(params.merge(organizer: @current_user))

        render json: {
            success: true,
            code: 200,
            data: PollSerializer.new( @current_user.polls ).serialize
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

    def analytics
        data = {
            message: "",
            analytics: ""
        }

        if current_poll.status == "Ended"
            data[:message] = "Poll Ended"
            data[:analytics] = PollSerializer.new( current_poll  ).serialize
        else
            data[:message] = "Poll results available when poll ends"
        end

        render json: {
            success: true,
            code: 200,
            data: data
        }
    end
end
