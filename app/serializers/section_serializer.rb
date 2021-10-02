class SectionSerializer < BaseSerializer
    def serialize_single(resource, _)
        data = {
            id: resource.id,
            description: resource.description,
            options: OptionSerializer.new( resource.options ).serialize
        }

        if resource.poll.status == "Ended"
            data[:options] = data[:options].sort { |a, b| b[:votes] <=> a[:votes] }
        end

        data
    end

end