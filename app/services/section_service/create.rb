module SectionService
    class Create < BaseService
        def initialize(params)
            @poll = params[:current_poll]
            @sections = params[:sections]
        end

        def call
            @sections.each do |section|
                new_section = @poll.sections.create(
                    description: section[:description]
                )
                
                section[:options].each do |option|
                    
                    new_option = new_section.options.create!(
                        description: option[:description],
                        image_url: option[:image_url]
                    )
                end
            end
        end
    end
end