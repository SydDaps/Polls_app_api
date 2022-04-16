class Poll < ApplicationRecord
    belongs_to :organizer
    has_many :sections, dependent: :destroy
    has_many :voters, dependent: :destroy
    has_many :votes, dependent: :destroy


    def total_voters
        self.voters.count
    end

    def total_votes
        self.votes.count
    end

    def  status
        if Time.now < self.start_at
            "Not Started"
        elsif Time.now > self.end_at
            "Ended"
        else
            "In Progress"
        end
    end

    module PublishedStatus
      PUBLISHED = 'published'
      PUBLISHING = 'publishing'
    end

    module PublishMedium
      SMS = 'sms'
      EMAIL = 'email'
    end
end
