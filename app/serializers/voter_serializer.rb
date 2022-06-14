class VoterSerializer < BaseSerializer
    def serialize_single(resource, _)
      data = {
        id: resource.id,
        phone_number: resource.phone_number,
        email: resource.email,
        index_number: resource.index_number,
        password_set: resource.password_set
      }
    end

end