class PublishJob < ApplicationJob
  queue_as :default

  def perform(params)
    params[:voters].each do |voter|
      pass_key = SecureRandom.hex(4)
      voter.update!(
        pass_key: BCrypt::Password.create(pass_key)
      )

      
      mail_params = {
        to: voter.email,
        template_id: "d-16b4b7d6a5f94bfa992b41a43a5cdcc7",
        template_data: {
          
          pass_key: pass_key,
          subject: "#{ params[:poll].title } voting link",
          index_number: voter.index_number,
          organization_name: params[:poll].organizer.name,
          poll_title: params[:poll].title,
          voter_link: "https://epic-polls.netlify.app/vote/#{params[:poll].id}",
          start_at: "#{params[:poll].start_at.strftime("%B %d, %Y %I:%M%P")}",
          end_at: "#{params[:poll].start_at.strftime("%B %d, %Y %I:%M%P")}"
        }
      }

      Mailer::Sender.send( mail_params )
    end




  end
end
