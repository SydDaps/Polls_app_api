module GeneralUserService
  class ResetPassword < BaseService
    def initialize(params)
      @password = params[:password]
      @password_confirmation = params[:password_confirmation]
      @reset_token = params[:reset_token]
      @email = params[:email]
      @user_type = params[:user_type]
    end

    def call
      raise ActiveRecord::RecordNotFound
      .new("Enter a user type") unless @user_type

      @user_type[0] =  @user_type[0].upcase

      case @user_type
      when "Agent"
        user = Agent.find_by(email: @email)
      when "Organizer"
        user = Organizer.find_by(email: @email)
      end

      raise ActiveRecord::RecordNotFound
      .new("#{@user_type} with email #{@email} is not registered.") unless user

      #validate reset_token and time
      unless user.reset_token_valid_time || user.reset_token
        raise Exceptions::UnauthorizedOperation
        .new("please request reset token to reset password.")
      end


      if DateTime.now > user.reset_token_valid_time
        user.update!(
          reset_token: nil,
          reset_token_valid_time: nil
        )

        raise Exceptions::UnauthorizedOperation
        .new("Reset token expired. request new token.")
      end

      reset_token_decoded = BCrypt::Password.new(user.reset_token)
      unless reset_token_decoded == @reset_token
        raise Exceptions::UnauthorizedOperation
        .new("Invalid reset token.")
      end

      user.update(
        password: @password,
        password_confirmation: @password_confirmation,
        reset_token: nil,
        reset_token_valid_time: nil
      )

      {message: "password reset successfully!"}
    end
  end
end