class OnboardingSerializer < BaseSerializer
  def serialize_single(resource, _)
    data = VoterSerializer.new( resource.voter ).serialize

    if resource.organizer
      added_by = resource.organizer.name
    elsif resource.agent
      added_by = resource.agent.name
    end

    data.merge(added_by: added_by)
  end
end