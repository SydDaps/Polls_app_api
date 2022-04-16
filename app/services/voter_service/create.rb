module VoterService
  class Create < BaseService
    def initialize(params)
      @params = params
    end

    def call
      response = validate_voter_params
      return response unless @fields

      response = check_uniqueness
      return response unless response[:success]

      response = create_voter

      return response unless @voter

      {
        success: true,
        voters: VoterSerializer.new( @poll.reload.voters.all ).serialize,
        voter: @voter
      }
    end


    def validate_voter_params
      @email = @params[:email].presence
      @phone_number = @params[:phone_number].presence
      @index_number = @params[:index_number].presence
      @poll = @params[:poll]

      required_params = {index_number: @index_number}

      at_least_one_of = {
        email: @email,
        phone_number: @phone_number
      }

      missing_params = []
      required_params.each do |key, value|
        missing_params.push(key) unless value
      end

      params_not_available = []
      at_least_one_of.each do |key, value|
        unless value
          at_least_one_of.delete(key)
          params_not_available.push(key)
        end
      end

      if at_least_one_of.empty?
        missing_params.push(params_not_available)
        missing_params = missing_params.flatten
      end

      unless missing_params.empty?
        return {
          success: false,
          message:"Missing Parameters #{missing_params.join(', ')}"
        }
      end

      @fields = required_params.merge(at_least_one_of)
    end


    def check_uniqueness
      @fields.each do |key, value|
        if key == :phone_number
          value = Phonelib.parse(value).e164
        end

        voter = @poll.voters.find_by(key => value)

        if voter
          data = voter.method(key).call
          return {
            success: false,
            message: "voter with #{key} #{data} already added"
          }
        end
      end

      {success: true}
    end

    def create_voter

      if @phone_number
        phone_valid = Phonelib.valid?(@phone_number)
        phone = Phonelib.parse(@phone_number)

        unless phone.country == "GH" && phone_valid
          return {
            success: false,
            message: "Phone number is not valid"
          }
        end

        @phone_number = phone.e164
        @fields[:phone_number] = phone.e164
      end

      @voter = @poll.voters.create(@fields)
    end
  end
end