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
        subject: "#{ params[:poll].title } voting link",
        template_name: "publish",
        template_data: {
          poll_id: params[:poll].id,
          pass_key: pass_key
        }
      }

      Mailer::Sender.send( mail_params )
    end




  end
end
