class PublishJob < ApplicationJob
  queue_as :default

  def perform(params)

    params[:poll].update(publish_status: Poll::PublishedStatus::PUBLISHING)

    params[:voters].each do |voter|
      pass_key = SecureRandom.hex(4)
      voter.update!(
        pass_key: BCrypt::Password.create(pass_key)
      )

      voter_link = "https://epic-polls.netlify.app/vote/#{params[:poll].id}"
      start_at = "#{params[:poll].start_at.strftime("%B %d, %Y %I:%M%P")}"
      end_at = "#{params[:poll].end_at.strftime("%B %d, %Y %I:%M%P")}"
      subject = "#{params[:poll].title} poll"
      index_number = voter.index_number
      organization_name = params[:poll].organizer.name
      poll_title = params[:poll].title

      if voter.email
        mail_params = {
          to: voter.email,
          template_id: "d-16b4b7d6a5f94bfa992b41a43a5cdcc7",
          template_data: {
            pass_key: pass_key,
            subject: subject,
            index_number: index_number,
            organization_name: organization_name,
            poll_title: poll_id,
            voter_link: voter_link,
            start_at: start_at,
            end_at: end_at
          }
        }
        Sender::Mailer.send( mail_params )
      elsif voter.phone_number
        sms_params = {
          to: voter.phone_number[1..],
          voter_link: voter_link,
          subject: subject,
          start_at: start_at,
          end_at: end_at,
          pass_key: pass_key,
          poll_title: poll_title,
          organization_name: organization_name,
        }
      end
    end

    params[:poll].update(publish_status: Poll::PublishedStatus::PUBLISHED)
  end
end
