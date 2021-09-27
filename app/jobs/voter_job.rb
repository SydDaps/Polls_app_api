class VoterJob < ApplicationJob
  queue_as :default

  def perform(params)
    puts params.class
    params[:voters].each do |data|

      user_found = Voter.find_by_email(data[:email])
      index_found = Voter.find_by_index_number(data[:index_number])

      next if user_found || index_found

      params[:poll].voters.create({

        email: data[:email],
        index_number: data[:index_number]

      })
    end
  end
end
