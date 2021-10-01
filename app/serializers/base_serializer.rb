class BaseSerializer
    def initialize(resource)
        @resource = resource
        @is_collection = @resource.respond_to?(:each)
    end

    def serialize(options = {})
    
        
        data = {}
        if @is_collection
            data = serialize_collection(@resource, options)
        else
            data = serialize_single(@resource, options)
        end
        
        

        unless options.empty?
            data = data.select { |key, i| options[:keys].include? key }
        end
        
        data
    end

    private

    def serialize_single(resource, options = {})
        raise NotImplementedError
    end
      # rubocop:enable Lint/UnusedMethodArgument
    
    def serialize_collection(resources, options = {})
        resources.map { |resource| serialize_single(resource, options) }
    end
end