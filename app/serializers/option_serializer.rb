class OptionSerializer < BaseSerializer
    def serialize_single(resource, _)
        data = {
            id: resource.id,
            description: resource.description,
            image_url: resource.image_url
        }

        if resource.section.poll.status == "Ended"
           data = data.merge({ total_votes: resource.total_votes })
        end

        data
    end

end