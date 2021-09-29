class Api::V1::SectionsController < ApplicationController
    before_action :current_poll

    def create

        response = SectionService::Create.call(params.merge(current_poll: @current_poll))


        render json: {
            success: true,
            code: 200,
            data: SectionSerializer.new( @current_poll.sections.all ).serialize
        }


    end

    def index

        render json: {
            success: true,
            code: 200,
            data: SectionSerializer.new( @current_poll.sections.all ).serialize
        }
    end



    private

    def current_poll
        @current_poll = Poll.find(params[:poll_id])
    end
end


