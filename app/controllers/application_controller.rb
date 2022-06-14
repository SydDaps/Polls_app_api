class ApplicationController < ActionController::API
    before_action :authenticate_request
    include ErrorHandler

    def authenticate_request
      @current_user = Auth::AuthorizeRequest.call(request.headers)
    end

    def current_poll
        authenticate_request
        if params[:id]
          @current_user.polls.find(params[:id]) if params[:id]
        else
          @current_user.polls.find(params[:poll_id])
        end
    end
end
