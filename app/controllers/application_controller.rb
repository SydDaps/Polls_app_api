class ApplicationController < ActionController::API
    before_action :authenticate_request
    include ErrorHandler

    def authenticate_request
        @current_organizer = Auth::AuthorizeRequest.call(request.headers)
    end
end
