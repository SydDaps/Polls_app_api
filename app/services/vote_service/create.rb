module VoteService
    class Create < BaseService

        def initialize(params)
            @poll = params[:poll]
            @voter = params[:voter]
            @votes = params[:votes]
        end


        def call
            poll_started = Time.now < @poll.start_at
            poll_ended = Time.now > @poll.end_at

            raise Exceptions::NotUniqueRecord.message("Poll starts at #{@poll.start_at.strftime("%B %d, %Y %I:%M%P")}") if poll_started
            raise Exceptions::NotUniqueRecord.message("Poll ended") if poll_ended

            raise Exceptions::NotUniqueRecord.message("Voted already") if @voter.voted           

            @votes.each do |data|
                Vote.create(
                    poll_id: @poll.id,
                    section_id: data[:section_id],
                    option_id: data[:option_id],
                    voter_id: @voter.id
                )
            end

            @voter.update(voted: true)
        end
    end
end