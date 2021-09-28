class VoterSerializer < BaseSerializer
    def serialize_single(resource, _)
        {
            id: resource.id,
            email: resource.email,
            index_number: resource.index_number
        }
    end

end