class AnalyticSerializer < BaseSerializer
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
            data[:total_voters] = resource.total_voters

            data[:sections].each_with_index do |section, i|
                data[:sections][i][:totaL_votes] = section.total_votes
            end
        end
    end


end