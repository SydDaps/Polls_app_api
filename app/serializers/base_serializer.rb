class BaseSerializer
    def initialize(resource)
        @resource = resource
        @is_collection = @resource.respond_to?(:each)
    end

    def serialize(options = {})
        if @is_collection
            serialize_collection(@resource, options)
        else
            serialize_single(@resource, options)
        end
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