class PollSerializer < BaseSerializer
    def serialize_single(resource, _)
        data = {
            id: resource.id,
            title: resource.title,
            description: resource.description,
            start_at: resource.start_at,
            end_at: resource.end_at,
            sections: SectionSerializer.new( resource.sections ).serialize
        }

        if resource.status == "Ended"
            data = data.merge({ 
                total_voters: resource.total_voters,
                total_votes: resource.total_votes
            })
        end

        data
    end



end