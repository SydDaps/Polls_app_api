class VoterSerializer < BaseSerializer
    def serialize_single(resource, _)
      data = {
        id: resource.id,
        phone_number: resource.phone_number,
        email: resource.email,
        index_number: resource.index_number
      }

      if resource.organizer
        added_by = resource.organizer.name
      elsif resource.agent
        added_by = resource.agent.name
      end

      data.merge(added_by: added_by)

    end

end