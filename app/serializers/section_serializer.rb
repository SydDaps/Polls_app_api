class SectionSerializer < BaseSerializer
    def serialize_single(resource, _)
        data = {
            id: resource.id,
            description: resource.description,
            options: OptionSerializer.new( resource.options ).serialize
        }

        if resource.poll.status == "Ended"
            data = data.merge({ total_votes: resource.total_votes })
        end

        data
    end

end