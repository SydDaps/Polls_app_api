module PollService
  class Edit < BaseService
    def initialize(params)
      @poll = params[:poll]
      @title = params[:title]
      @start_at = params[:start_at]
      @end_at = params[:end_at]
      @description = params[:description]
    end

    def call
      unless @poll.status == "Not Started"
        return {
          success: false,
          message: "Poll details can not be changed after poll had started."
        }
      end

      @poll.update(
        title: @title,
        description: @description,
        start_at: @start_at,
        end_at: @end_at
      )

      @poll.reload
    end
  end
end