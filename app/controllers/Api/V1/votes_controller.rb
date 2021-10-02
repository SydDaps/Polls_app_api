class Api::V1::VotesController < ApplicationController

    def create
        
        VoteService::Create.call(params.merge({
            poll: current_poll,
            voter: @current_user
        }))
        
        ActionCable.server.broadcast("admin_#{@current_user.id}",
        {
            data: {
                analytics: PollSerializer.new( current_poll  ).serialize
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
