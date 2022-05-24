module VoterService
  class Create < BaseService
    def initialize(params)
      @email = params[:email].presence
      @phone_number = params[:phone_number].presence
      @index_number = params[:index_number].presence
      @poll = params[:poll]
      @organizer_id = params[:organizer_id]
      @agent_id = params[:agent_id]
    end

    def call
      response = parse_phone_number
      return response unless response[:success]

      response = check_uniqueness
      return response unless response[:success]

      response = create_voter
      return response unless response[:success]

      {
        success: true,
        voters: VoterSerializer.new( @poll.reload.voters.all ).serialize,
        voter: @voter
      }
    end

    def check_uniqueness
      @fields = {
        index_number: @index_number,
        phone_number: @phone_number,
        email: @email
      }

      @fields.each do |key, value|
        next unless value

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
      @voter = @poll.voters.create(
        @fields.merge(
          organizer_id: @organizer_id,
          agent_id: @agent_id
        )
      )

      unless @voter.valid?
        error_messages = []
        @voter.errors.messages.each{ |key, value| error_messages.push("#{key} #{value.join(",")}") }
        return {
          success: false,
          message: error_messages.join(", ")
        }
      end

      {success: true}
    end

    def parse_phone_number
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
      end

      {success: true}
    end
  end
end