module PollService 
    class Create < BaseService
        def initialize(poll_params)
          @organizer = poll_params[:organizer]
          @poll_title = poll_params[:title]
          @poll_start_at = poll_params[:start_at]
          @poll_end_at = poll_params[:end_at]
        end

        def call
            
            poll = @organizer.polls.create(
                title: @poll_title,
                start_at: @poll_start_at,
                end_at: @poll_end_at   
            )
        end


    end
end