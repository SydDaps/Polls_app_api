class Api::V1::VotersController < ApplicationController

    def create
      params.permit!
      voters = params[:voters]


      VoterJob.perform_later(
        {
          voters: voters,
          poll: current_poll
        }
      )

      # emails.each do |data|

      #   user_found = Voter.find_by_email(data[:email])
      #   index_found = Voter.find_by_index_number(data[:index_number])

      #   next if user_found || index_found

      #   current_poll.voters.create({

      #     email: data[:email],
      #     index_number: data[:index_number]

      #   })

      # end

      
      render json: {
        success: true,
        code: 200,
        data: {
          messages: "Adding Voters",
        }
      }
    end
end
