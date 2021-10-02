class Api::V1::VotesController < ApplicationController

    def create
        
        VoteService::Create.call(params.merge({
            poll: current_poll,
            voter: @current_user
        }))
        
        ActionCable.server.broadcast("admin_#{@current_user.poll.organizer.id}",
        {
            data: {
                analytics: {
                    message: "Poll results will be available on #{current_poll.end_at.strftime("%B %d, %Y %I:%M%P")}",
                    analytics: PollSerializer.new( params[:poll]  ).serialize
                }
            }
        })

        render json: {
            success: true,
            code: 200,
            data: {
                message: "voted Successfully"
            }
        } 
    end
end
