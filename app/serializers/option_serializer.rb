class OptionSerializer < BaseSerializer
    def serialize_single(resource, _)
        data = {
          id: resource.id,
          description: resource.description,
          image_url: resource.image_url
        }

        if resource.sub_options.present?
          data = data.merge({
            sub_options: OptionSerializer.new( resource.sub_options ).serialize
          })
        end

        if resource.section.poll.status == "Ended" && !resource.has_sub_options?
          data = data.merge({
            votes: resource.total_votes,
            votes_percentage: ((resource.total_votes.to_f / resource.section.total_votes) * 100.0).round(2)
          })
        end

        data
    end

end