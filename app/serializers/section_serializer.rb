class SectionSerializer < BaseSerializer
    def serialize_single(resource, _)
        data = {
            id: resource.id,
            description: resource.description,
            options: OptionSerializer.new( resource.options.are_super_options ).serialize
        }

        if resource.poll.status == "Ended"
            data = data.merge({
                votes: resource.total_votes
            })

            data[:options] = data[:options].sort { |a, b| b[:votes] <=> a[:votes] }
        end



        data
    end

end