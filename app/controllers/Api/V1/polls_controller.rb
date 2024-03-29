class Api::V1::PollsController < ApplicationController
    skip_before_action :authenticate_request, :only => [:analytics]

    def index

        render json: {
            success: true,
            code: 200,
            data: PollSerializer.new( @current_user.polls.all.order(created_at: :desc) ).serialize
        }

    end

    def create
        response = PollService::Create.call(params.merge(organizer: @current_user))

        render json: {
          success: true,
          code: 200,
          data: PollSerializer.new( @current_user.polls.all.order(created_at: :desc) ).serialize
        }
    end

    def update
      response = PollService::Edit.call(params.merge(poll: current_poll))

      unless response[:success]
        data = response
      else
        data = PollSerializer.new( response ).serialize
      end

      render json: {
        success: true,
        code: 200,
        data: data
      }
    end

    def show
        if @current_user.class.name == "Voter"
            data = { }

            if current_poll.status == "Not Started"
              data[:message] = "Poll starts on #{current_poll.start_at.strftime("%B %d, %Y %I:%M%P")}."
              data[:overview] = PollSerializer.new( current_poll  ).serialize({keys: [:id, :start_at, :end_at, :status]})
            elsif current_poll.status.downcase == "ended"
              data[:message] = "Poll Ended"
              data[:analytics] = PollSerializer.new( current_poll  ).serialize
            elsif @current_user.has_voted(current_poll.id)
              data[:message] = "You have already voted \n Poll results will be available on #{current_poll.end_at.strftime("%B %d, %Y %I:%M%P")}."
            elsif current_poll.status == "In Progress"
              data[:poll] = PollSerializer.new( current_poll  ).serialize
            end

            render json: {
              success: true,
              code: 200,
              data: data
            }
        else
            render json: {
              success: true,
              code: 200,
              data: PollSerializer.new( current_poll ).serialize
            }
        end
    end

    def analytics
        data = {
          message: "",
          analytics: {}
        }

        if current_poll.status == "Ended"
          data[:message] = "Poll Ended"
        elsif current_poll.status == "Not Started"
          data[:message] = "Poll starts on #{current_poll.start_at.strftime("%B %d, %Y %I:%M%P")}"
        else
          data[:message] = "Poll results will be available on #{current_poll.end_at.strftime("%B %d, %Y %I:%M%P")}"
        end

        data[:analytics] = PollSerializer.new( current_poll  ).serialize

        render json: {
          success: true,
          code: 200,
          data: data
        }
    end
end