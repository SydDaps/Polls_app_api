module PollService 
    class Create < BaseService
        def initialize(poll_params)
          @organizer = poll_params[:organizer]
          @title = poll_params[:title]
          @description = poll_params[:description]
          @start_at = poll_params[:start_at]
          @end_at = poll_params[:end_at]
        end

        def call
            
            poll = @organizer.polls.create(
                title: @title,
                description: @description,
                start_at: @start_at,
                end_at: @end_at   
            )
        end


    end
end