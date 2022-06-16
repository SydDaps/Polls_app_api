module VoteService
    class Create < BaseService

        def initialize(params)
            @poll = params[:poll]
            @voter = params[:voter]
            @votes = params[:votes]
        end


        def call


            raise Exceptions::NotUniqueRecord.message("Poll starts at #{@poll.start_at.strftime("%B %d, %Y %I:%M%P")}") if @poll.status == "Not Started"
            raise Exceptions::NotUniqueRecord.message("Poll ended") if @poll.status == "Ended"

            raise Exceptions::NotUniqueRecord.message("Voted already") if @voter.has_voted(@poll_id)

            @votes.each do |data|
                Vote.create(
                    poll_id: @poll.id,
                    section_id: data[:section_id],
                    option_id: data[:option_id],
                    voter_id: @voter.id
                )
            end
        end
    end
end