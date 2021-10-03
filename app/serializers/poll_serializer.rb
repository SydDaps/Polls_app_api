class PollSerializer < BaseSerializer
    def serialize_single(resource, _)
        {
            id: resource.id,
            title: resource.title,
            description: resource.description,
            start_at: resource.start_at,
            end_at: resource.end_at,
            status: resource.status,
            total_voters: resource.total_voters,
            total_votes: resource.voters.where(voted: true).count,
            total_voted_percentage: ((resource.total_votes.to_f / resource.total_voters) * 100.0).round(2),
            sections: SectionSerializer.new( resource.sections ).serialize
        }
    end



end