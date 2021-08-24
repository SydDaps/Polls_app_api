module ErrorHandler
    extend ActiveSupport::Concern

    included do
        rescue_from ActiveRecord::RecordInvalid do |e|
            error_response = {
                success: false,
                code: 400,
                message: e.message,
            }
            render json: error_response
        end

        rescue_from ActiveRecord::RecordNotUnique do |e|
            error_response = {
                success: false,
                code: 400,
                message: "User already has account",
            }
            render json: error_response
        end

        rescue_from Exceptions::UnauthorizedOperation do |e|
            
            error_response = {
                success: false,
                code: 401,
                message: e.message,
            }
            render json: error_response
        end

        rescue_from Exceptions::MissingParam do |e|
            
            error_response = {
                success: false,
                code: 401,
                message: e.message,
            }
            render json: error_response
        end

        rescue_from Exceptions::NotUniqueRecord do |e|
            error_response = {
                success: false,
                code: 401,
                message: e.message,
            }
            render json: error_response
        end


        rescue_from ActiveRecord::RecordNotFound do |e|
            error_response = {
                success: false,
                code: 401,
                message: e.message,
            }
            render json: error_response
        end

        rescue_from Exceptions::ExpiredToken do |e|
            error_response = {
                success: false,
                code: 401,
                error: "expired_token",
                message: e.message,
            }
            render json: error_response
        end
    end



end