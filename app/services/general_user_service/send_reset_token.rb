module GeneralUserService
  class SendResetToken < BaseService
    def initialize(params)
      @poll = params[:poll]
      @email = params[:email]
      @user_type = params[:user_type]
    end

    def call
      raise ActiveRecord::RecordNotFound
      .new("Enter a user_type") unless @user_type

      @user_type[0] =  @user_type[0].upcase
      case @user_type
      when "Agent"
        user = Agent.find_by(email: @email)
      when "Organizer"
        user = Organizer.find_by(email: @email)
      end

      raise ActiveRecord::RecordNotFound
      .new("#{@user_type} with email #{@email} is not a registered with the app.") unless user

      reset_token = SecureRandom.uuid
      reset_token_valid_time = DateTime.now + 10.minutes
      user.update!(
        reset_token: BCrypt::Password.create(reset_token),
        reset_token_valid_time: reset_token_valid_time
      )

      mail_params = {
        to: user.email,
        organization_name: "Polyticks app",
        template_id: ENV["RESET_PASSWORD_TEMPLATE_ID"],
        template_data: {
          reset_token: reset_token,
          expires_in: reset_token_valid_time.strftime("%m-%d-%Y %I:%M%p"),
          subject: "Polyticks app agent password reset"
        }
      }

      Sender::Mailer.send( mail_params )

      {
        message: "A reset token has been sent to email."
      }
    end
  end
end