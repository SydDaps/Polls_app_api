module GeneralUserService
  class SendResetToken < BaseService
    def initialize(params)
      @email = params[:email]
      @user_type = params[:user_type]
    end

    def call
      raise ActiveRecord::RecordNotFound
      .new("Enter a user_type") unless @user_type


      case @user_type
      when "agent"
        user = Agent.find_by(email: @email)
      when "organizer"
        user = Organizer.find_by(email: @email)
      when "voter"
        user = Voter.find_by(email: @email)
      end

      unless user
        @user_type[0] =  @user_type[0].upcase
        raise ActiveRecord::RecordNotFound
        .new("#{@user_type} with email #{@email} is not a registered with the app.")
      end

      expires_in = 11.minutes.from_now
      token = JWT::JsonWebToken.encode(
        {"#{@user_type}_id": user.id},
        expires_in
      )

      mail_params = {
        to: user.email,
        organization_name: "Polyticks",
        template_id: ENV["RESET_PASSWORD_TEMPLATE_ID"],
        template_data: {
          reset_link: "https://www.polyticks.app/forgot?token=#{token}",
          expires_in: 10.minutes.from_now.strftime("%m-%d-%Y %I:%M%p"),
          subject: "Polyticks #{@user_type} password reset"
        }
      }

      puts mail_params

      Sender::Mailer.send( mail_params )

      {
        message: "A reset token has been sent to your email."
      }
    end
  end
end