class ApplicationController < ActionController::API
    before_action :authenticate_request
    include ErrorHandler

    def authenticate_request
      @current_user = Auth::AuthorizeRequest.call(request.headers)
    end

    def current_poll
        return Poll.find(params[:id]) if params[:id]
        Poll.find(params[:poll_id])
    end
end
