module VoterService
  class Create < BaseService
    def initialize(params)
      @email = params[:email]
      @phone_number = Phonelib.parse(params[:phone_number]).e164
      @index_number = params[:index_number]
      @poll = params[:poll]
    end

    def call
      return {success: false, message: "provide an index_number"} unless @index_number

      unless (@phone_number && Phonelib.valid?(@phone_number)) || @email
        return {success: false, message: "provide an email or valid phone number"}
      end

      if @email
        voter_email = @poll.voters.find_by(email: @email)
      end

      if @phone_number
        voter_phone = @poll.voters.find_by(phone_number: @phone_number)
      end

      voter_index_number = @poll.voters.find_by(index_number: @index_number)

      if voter_email
        message = "voter with #{voter_email.email} already added"
      elsif voter_phone
        message = "voter with #{voter_phone.phone_number} already added"
      elsif voter_index_number
        message = "voter with #{voter_index_number.index_number} already added"
      end

      return {success: false, message: message} if message

      voter = @poll.voters.create({
        email: @email,
        index_number:@index_number,
        phone_number: @phone_number
      })

      {
        success: true,
        voters: VoterSerializer.new( @poll.reload.voters.all ).serialize
      }
    end
  end
end