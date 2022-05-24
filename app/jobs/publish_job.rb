class PublishJob < ApplicationJob
  queue_as :default

  def perform(params)
    @poll = params[:poll]
    @voters = params[:voters]
    @voter_link = "https://epic-polls.netlify.app/vote/#{@poll.id}"
    @start_at = "#{@poll.start_at.strftime("%B %d, %Y %I:%M%P")}"
    @end_at = "#{@poll.end_at.strftime("%B %d, %Y %I:%M%P")}"
    @subject = "#{@poll.title} poll"
    @organization_name = @poll.organizer.name
    @poll_title = @poll.title
    @template_id = ENV['POLL_LINK_TEMPLATE_ID']

    @poll.update(publish_status: Poll::PublishedStatus::PUBLISHING)

    @voters.each do |voter|
      @voter = voter
      @index_number = voter.index_number
      @pass_key = SecureRandom.hex(4)

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

        if update
          update_voter
        end
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
      index_number: @index_number,
      sender_id: @poll.meta["sms_subject"]
    }

   response =  Sender::Sms.new(sms_params).send_hellio

   unless response
    response =  Sender::Sms.new(sms_params).send_arkesel
   end

   response
  end


  def update_voter
    @voter.update!(
      pass_key: BCrypt::Password.create(@pass_key)
    )
  end
end


