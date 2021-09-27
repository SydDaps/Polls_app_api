class ApplicationController < ActionController::API
    before_action :authenticate_request
    include ErrorHandler

    def authenticate_request
        @current_organizer = Auth::AuthorizeRequest.call(request.headers)
    end

    def current_poll
        Poll.find(params[:poll_id])
    end
end
