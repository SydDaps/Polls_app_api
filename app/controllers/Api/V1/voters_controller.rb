class Api::V1::VotersController < ApplicationController
  skip_before_action :authenticate_request, :only => [:login]

  def create
    params.permit!
    voters = params[:voters]


    VoterJob.perform_later(
      {
        voters: voters,
        poll: current_poll,
        user: @current_user
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
      data: VoterSerializer.new( current_poll.voters.all ).serialize
    }
  end

  def login
    voter = current_poll.voters.find_by_index_number(params[:index_number])

    raise Exceptions::NotUniqueRecord.message("The index number #{params[:index_number]} is not registered with this poll.") unless voter
    
    pass_hash = BCrypt::Password.new(voter.pass_key)

    unless pass_hash == params[:pass_key]

      raise Exceptions::NotUniqueRecord.message("Invalid Pass Key")

    end

    token = JWT::JsonWebToken.encode({voter_id: voter.id}) if voter

    render json: {
      success: true,
      code: 200,
      data: {
        user: voter,
        access_token: token,
        poll: PollSerializer.new( current_poll ).serialize
      },
    }
  end

  def publish
    if params[:voter_id]
      voters = [current_poll.voters.find(params[:voter_id])]
    else
      voters = current_poll.voters.all.where(pass_key: nil)
    end

    PublishJob.perform_now({
     voters: voters,
     poll: current_poll 
    })

    render json: {
      success: true,
      code: 200,
      message: "Poll is being Published to voters"
    }
  end
end
