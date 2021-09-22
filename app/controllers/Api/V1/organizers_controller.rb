
class Api::V1::OrganizersController < ApplicationController
  skip_before_action :authenticate_request

  def create
      response = OrganizerService::Create.call(params)
      
      #WelcomeMailer.new_organizer_email(response[:organizer]).deliver_now

      # from = SendGrid::Email.new(email: 'Pent polls <mailer@timetablr.xyz>')
      # to = SendGrid::Email.new(email: 'kakyena02@gmail.com')
      # subject = 'Sending with SendGrid is Fun'
      # content = SendGrid::Content.new(type: 'text/plain', value: 'and easy to do anywhere, even with Ruby')
      # mail = SendGrid::Mail.new(from, subject, to, content)

      # sg = SendGrid::API.new(api_key: ENV['API_KEY'])
      # status = sg.client.mail._('send').post(request_body: mail.to_json)
      

      render json: {
          success: true,
          code: 200,
          data: {
            token: response[:token],
            Organizer: response[:organizer]
          }
        }
  end
end
