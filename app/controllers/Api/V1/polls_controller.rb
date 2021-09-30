class Api::V1::PollsController < ApplicationController
    skip_before_action :authenticate_request, :only => [:analytics]

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
            analytics: {}
        }

        if current_poll.status == "Ended"
            data[:message] = "Poll Ended"
        else
            data[:message] = "Poll results will be available when poll ends"
        end

        data[:analytics] = PollSerializer.new( current_poll  ).serialize

        render json: {
            success: true,
            code: 200,
            data: data
        }
    end
end
