module GeneralUserService
  class ResetPassword < BaseService
    def initialize(params)
      @poll = params[:poll]
      @password = params[:password]
      @password_confirmation = params[:password_confirmation]
      @reset_token = params[:reset_token]
      @email = params[:email]
    end

    def call
      agent = @poll.agents.find_by(email: @email)
      raise ActiveRecord::RecordNotFound
      .new("Agent with email #{@email} is not registered with this poll.") unless agent

      #validate reset_token and time
      unless agent.reset_token_valid_time || agent.reset_token
        raise Exceptions::UnauthorizedOperation
        .new("please request reset token to reset password.")
      end


      if DateTime.now > agent.reset_token_valid_time
        agent.update!(
          reset_token: nil,
          reset_token_valid_time: nil
        )

        raise Exceptions::UnauthorizedOperation
        .new("Reset token expired. request new token.") unless agent
      end

      reset_token_decoded = BCrypt::Password.new(agent.reset_token)
      unless reset_token_decoded == @reset_token
        raise Exceptions::UnauthorizedOperation
        .new("Invalid reset token.")
      end

      agent.update(
        password: @password,
        password_confirmation: @password_confirmation,
        reset_token: nil,
        reset_token_valid_time: nil
      )

      {message: "password reset successfully!"}
    end
  end
end