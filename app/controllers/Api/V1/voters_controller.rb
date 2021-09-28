class Api::V1::VotersController < ApplicationController
  skip_before_action :authenticate_request, :only => [:login]

  def create
    params.permit!
    voters = params[:voters]


    VoterJob.perform_later(
      {
        voters: voters,
        poll: current_poll
      }
    )

    render json: {
      success: true,
      code: 200,
      data: {
        messages: "Adding Voters"
      }
    }
  end

  def index
    render json: {
      success: true,
      code: 200,
      data: {
        voters: VoterSerializer.new( current_poll.voters.all ).serialize
      }
    }
  end

  def login
    voter = current_poll.voters.find_by_index_number(params[:index_number])

    token = JWT::JsonWebToken.encode({voter_id: voter.id}) if voter

    raise Exceptions::NotUniqueRecord.message("The index number #{params[:index_number]} is not registered with this poll.") unless voter

    render json: {
      success: true,
      code: 200,
      data: {
        user: voter,
        access_token: token
      },
    }

  end
end
