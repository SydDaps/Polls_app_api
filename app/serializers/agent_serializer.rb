class AgentSerializer < BaseSerializer
  def serialize_single(resource, _)
    {
      id: resource.id,
      name: resource.name,
      email: resource.email
    }
  end
end