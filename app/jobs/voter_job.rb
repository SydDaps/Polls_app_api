class VoterJob < ApplicationJob
  queue_as :default

  def perform(params)
    params[:voters].each do |voter|

      poll = params[:poll]
      organizer = poll.organizer

      response = VoterService::Create.call(
        voter.merge(
          poll: poll,
          organizer_id: organizer.id
        )
      )

      next unless response[:voter]
      ActionCable.server.broadcast("admin_#{params[:user].id}",
        {
            data: {
              voters: response[:voter],
              analytics: {
                message: "Poll results will be available on #{params[:poll].end_at.strftime("%B %d, %Y %I:%M%P")}",
                analytics: PollSerializer.new( params[:poll]  ).serialize
              }
            }
        }
      )
    end
  end
end
