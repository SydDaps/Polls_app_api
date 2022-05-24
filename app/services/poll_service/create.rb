module PollService
    class Create < BaseService
        def initialize(poll_params)
          @organizer = poll_params[:organizer]
          @title = poll_params[:title]
          @description = poll_params[:description]
          @start_at = poll_params[:start_at]
          @end_at = poll_params[:end_at]
          @publish_mediums = poll_params[:publish_mediums]
          @meta = poll_params[:meta]
          @sms_subject = poll_params[:sms_subject].presence
        end

        def call
          meta = {
            sms_subject: @sms_subject
          }


          poll = @organizer.polls.create!(
            title: @title,
            description: @description,
            start_at: @start_at,
            end_at: @end_at,
            publish_mediums: @publish_mediums,
            meta: meta
          )
        end
    end
end