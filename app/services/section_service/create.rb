module SectionService
    class Create < BaseService
        def initialize(params)
          @poll = params[:current_poll]
          @sections = params[:sections]
        end

        def call
          Section.transaction do
            unless @poll.status == "Not Started"
              return {
                success: false,
                message: "Section and Option details can not be changed after poll had started."
              }
            end

            @poll.sections.destroy_all

            @sections.each do |section|
                new_section = @poll.sections.create(
                  description: section[:description]
                )

                section[:options].each do |option|

                  new_option = new_section.options.create!(
                    description: option[:description],
                    image_url: option[:image_url]
                  )

                  next unless option[:sub_options]
                  option[:sub_options].each do |sub_option|
                    new_section.options.create!(
                      description: sub_option[:description],
                      image_url: sub_option[:image_url],
                      super_option_id: new_option.id
                    )
                  end
                end
            end
          end

          {success: true}
        end
    end
end