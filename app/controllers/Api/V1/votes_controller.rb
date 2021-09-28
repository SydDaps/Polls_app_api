class Api::V1::VotesController < ApplicationController

    def create
        
        VoteService::Create.call(params.merge({
            poll: current_poll,
            voter: @current_user
        }))

        render json: {
            success: true,
            code: 200,
            data: {
                message: "voted Successfully"
            }
        }
    end
end
