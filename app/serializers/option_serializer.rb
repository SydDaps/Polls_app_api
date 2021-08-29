class OptionSerializer < BaseSerializer
    def serialize_single(resource, _)
        {
            id: resource.id,
            description: resource.description,
            image_url: resource.image_url
        }
    end

end