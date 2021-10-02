class VoterJob < ApplicationJob
  queue_as :default

  def perform(params)
    puts params.class
    params[:voters].each do |data|

      user_found = params[:poll].voters.find_by_email(data[:email])
      index_found = params[:poll].voters.find_by_index_number(data[:index_number])

      next if user_found || index_found

      next unless data[:email] || data[:index_number]

      voter = params[:poll].voters.create({

        email: data[:email],
        index_number: data[:index_number]

      })

      ActionCable.server.broadcast("admin_#{params[:user].id}",
        {
            data: {
              voters: voter,
              analytics: {
                message: "Poll results will be available at #{params[:poll].end_at.strftime("%B %d, %Y %I:%M%P")}",
                analytics: PollSerializer.new( params[:poll]  ).serialize
              }
            }
        }
      )
    end
  end
end
