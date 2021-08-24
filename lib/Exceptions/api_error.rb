module Exceptions
    class ApiError < StandardError
        def initialize(message="some thing went wrong", code=nil)
          super(message)
          @code = code
        end

        def self.message(msg, code=nil)
          new(msg, code)
        end
    end
end