class Api::V1::VotersController < ApplicationController
  skip_before_action :authenticate_request, :only => [:login]

  def create
    params.permit!


    if params[:single]
      params[:voter][:poll] = current_poll
      response = VoterService::Create.call(params[:voter])

      unless response[:success]
        raise Exceptions::NotUniqueRecord.message(response[:message])
      end

      data = response[:voters]

    elsif params[:bulk]

      VoterJob.perform_later(
        {
          voters: params[:voters],
          poll: current_poll,
          user: @current_user
        }
      )

      data = {message: "Voters are being added"}

    end

    render json: {
      success: true,
      code: 200,
      data: data
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
    if current_poll.publish_status == Poll::PublishedStatus::PUBLISHING
      message = "Currently Publishing to voters. Please try again later."
    else
      if params[:voter_id]
        voters = [current_poll.voters.find(params[:voter_id])]
      else
        voters = current_poll.voters.all.where(pass_key: nil)
      end

      PublishJob.perform_later({
      voters: voters.to_a,
      poll: current_poll
      })

    end

    is_published = true if current_poll.publish_status == Poll::PublishedStatus::PUBLISHED
    render json: {
      success: true,
      code: 200,
      message: message || "Poll is being published to voters",
      is_published: is_published || false
    }
  end
end
