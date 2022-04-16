class PublishJob < ApplicationJob
  queue_as :default

  def perform(params)
    @poll = params[:poll]
    @voters = params[:voters]

    @poll.update(publish_status: Poll::PublishedStatus::PUBLISHING)

    @voters.each do |voter|

      @pass_key = SecureRandom.hex(4)

      voter.update!(
        pass_key: BCrypt::Password.create(pass_key)
      )

      @voter = voter
      @voter_link = "https://epic-polls.netlify.app/vote/#{@poll.id}"
      @start_at = "#{@poll.start_at.strftime("%B %d, %Y %I:%M%P")}"
      @end_at = "#{@poll.end_at.strftime("%B %d, %Y %I:%M%P")}"
      @subject = "#{@poll.title} poll"
      @index_number = voter.index_number
      @organization_name = @poll.organizer.name
      @poll_title = @poll.title

      case @poll.publish_medium
      when Poll::PublishMedium::EMAIL
        send_mail
      when Poll::PublishMedium::SMS
        send_sms
      end
    end

    params[:poll].update(publish_status: Poll::PublishedStatus::PUBLISHED)

  end

  def send_mail
    mail_params = {
      to: @voter.email,
      template_id: "d-16b4b7d6a5f94bfa992b41a43a5cdcc7",
      template_data: {
        pass_key: @pass_key,
        subject: @subject,
        index_number: @index_number,
        organization_name: @organization_name,
        poll_title: @poll_title,
        voter_link: @voter_link,
        start_at: @start_at,
        end_at: @end_at
      }
    }

    Sender::Mailer.send( mail_params )
  end

  def send_sms
    sms_params = {
      to: @voter.phone_number[1..],
      voter_link: @voter_link,
      subject: @subject,
      start_at: @start_at,
      end_at: @end_at,
      pass_key: @pass_key,
      poll_title: @poll_title,
      organization_name: @organization_name,
      index_number: @index_number
    }

    Sender::Sms.send( sms_params )
  end
end
