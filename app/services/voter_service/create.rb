module VoterService
  class Create < BaseService
    def initialize(params)
      @email = params[:email]&.downcase.presence
      @phone_number = params[:phone_number].presence
      @index_number = params[:index_number].presence
      @poll = params[:poll]
      @organizer_id = params[:organizer_id]
      @agent_id = params[:agent_id]
    end

    def call
      response = create_voter
      return response unless response[:success]

      {
        success: true,
        voters: OnboardingSerializer.new( @poll.reload.onboardings ).serialize,
        voter: OnboardingSerializer.new( @voter.onboardings.where(poll_id: @poll.id)[0] ).serialize[0]
      }
    end

    def create_voter
      parse_phone_number if @phone_number

      @fields = {
        phone_number: @phone_number,
        email: @email
      }

      @fields.each do |key, value|
        next unless value

        @voter = Voter.find_by(key => value)
        break if @voter
      end

      poll = @voter&.polls&.where(id: @poll.id)&.first

      if poll
        return {
          success: false,
          message: "voter with credentials #{@fields.values.join(", ")} already added to poll"
        }
      elsif !@voter
        @voter = Voter.create(@fields)
      end

      @onboarding = @poll.onboardings.create(
        voter_id: @voter.id,
        agent_id: @agent_id,
        organizer_id: @organizer_id
      )

      [@voter, @onboarding].each do |entity|
        unless entity.valid?
          error_messages = []
          entity.errors.messages.each{ |key, value| error_messages.push("#{key} #{value.join(",")}") }
          return {
            success: false,
            message: error_messages.join(", ")
          }
        end
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




# Voter.all.each do |voter|
#   voter.polls.push(Poll.find(voter.poll_id))
#   voter.save
# end

# Voter.all.each do |voter|
#    Onboarding.create!(
#       voter: voter,
#       poll_id: voter.poll_id,
#       organizer: Poll.find(voter.poll_id).organizer,
#       has_voted: !voter.votes.empty?
#     )
# end


