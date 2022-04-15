class VoterJob < ApplicationJob
  queue_as :default

  def perform(params)
    params[:voters].each do |voter|

      response = VoterService::Create.call(voter.merge(poll: params[:poll]))
      puts "------------"
      puts response

      ActionCable.server.broadcast("admin_#{params[:user].id}",
        {
            data: {
              voters: response[:voter]
            }
        }
      )
    end
  end
end
