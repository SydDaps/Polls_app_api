class PublishJob < ApplicationJob
  queue_as :default

  def perform(params)
    @poll = params[:poll]
    @voters = params[:voters]
    @voter_link = "https://polyticks.app/"
    @start_at = "#{@poll.start_at.strftime("%B %d, %Y %I:%M%P")}"
    @end_at = "#{@poll.end_at.strftime("%B %d, %Y %I:%M%P")}"
    @subject = "#{@poll.title}"
    @organization_name = @poll.organizer.name
    @poll_title = @poll.title
    @template_id = ENV['POLL_LINK_TEMPLATE_ID']

    @poll.update(publish_status: Poll::PublishedStatus::PUBLISHING)

    @voters.each do |voter|
      @voter = voter

      @temporary_password = SecureRandom.hex(4) unless voter.password_set

      @poll.publish_mediums.each do |medium|
        case medium
        when Poll::PublishingMedium::EMAIL

          next unless @voter.email

          send_mail

          update = true

        when Poll::PublishingMedium::SMS

          next unless @voter.phone_number

          update = send_sms

        end

        update_voter if update
      end
    end

    @poll.update(publish_status: Poll::PublishedStatus::PUBLISHED)

  end

  def send_mail
    mail_params = {
      to: @voter.email,
      template_id: @template_id,
      organization_name: @organization_name,
      template_data: {
        temporary_password: @temporary_password,
        subject: @subject,
        email: @voter.email,
        organization_name: @organization_name,
        poll_title: @poll_title,
        voter_link: @voter_link,
        start_at: @start_at,
        end_at: @end_at,
        password_set: @voter.password_set
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
      temporary_password: @temporary_password,
      poll_title: @poll_title,
      organization_name: @organization_name,
      sender_id: @poll.meta["sms_subject"],
      phone_number: "0#{@voter.phone_number[4..]}",
      password_set: @voter.password_set
    }

   response =  Sender::Sms.new(sms_params).send_hellio

   unless response
    response =  Sender::Sms.new(sms_params).send_arkesel
   end

   response
  end


  def update_voter
    @voter.update(
      password: @temporary_password
    )
  end
end


