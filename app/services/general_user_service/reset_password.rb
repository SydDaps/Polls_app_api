module GeneralUserService
  class ResetPassword < BaseService
    def initialize(params)
      @password = params[:password]
      @password_confirmation = params[:password_confirmation]
      @user = params[:current_user]
    end

    def call
      unless @password == @password_confirmation
        return {message: "Passwords do not match"}
      end
      @user.update!(
        password: @password,
        password_confirmation: @password_confirmation
      )

      if @current_user.type == "voter"
        @current_user.update!(password_set: true)
      end

      {message: "Password reset is successful."}
    end
  end
end