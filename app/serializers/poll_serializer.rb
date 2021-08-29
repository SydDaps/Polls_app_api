class PollSerializer < BaseSerializer
    def serialize_single(resource, _)
        {
            id: resource.id,
            title: resource.title,
            description: resource.description,
            start_at: resource.start_at,
            end_at: resource.end_at,
            sections: SectionSerializer.new( resource.sections ).serialize
        }
    end


end