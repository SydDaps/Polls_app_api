class SectionSerializer < BaseSerializer
    def serialize_single(resource, _)
        {
            id: resource.id,
            description: resource.description,
            options: OptionSerializer.new( resource.options ).serialize
        }
    end

end