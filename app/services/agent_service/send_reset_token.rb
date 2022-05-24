module AgentService
  class SendResetToken < BaseService
    def initialize(params)
      @poll = params[:poll]
      @email = params[:email]
    end

    def call
      agent = @poll.agents.find_by(email: @email)
      raise ActiveRecord::RecordNotFound
      .new("Agent with email #{@email} is not registered with this poll") unless agent

      reset_token = SecureRandom.uuid
      reset_token_valid_time = DateTime.now + 10.minutes
      agent.update!(
        reset_token: BCrypt::Password.create(reset_token),
        reset_token_valid_time: reset_token_valid_time
      )

      mail_params = {
        to: agent.email,
        organization_name: @poll.organizer.name,
        template_id: ENV["RESET_PASSWORD_TEMPLATE_ID"],
        template_data: {
          reset_token: reset_token,
          expires_in: reset_token_valid_time
          subject: "#{@poll.title} agent password reset"
        }
      }

      Sender::Mailer.send( mail_params )

      {
        message: "A reset token has been sent to your email."
      }
    end
  end
end