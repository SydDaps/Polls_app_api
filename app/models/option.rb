class Option < ApplicationRecord
    belongs_to :section
    belongs_to :poll
    has_many :votes, dependent: :destroy

    def total_votes
        self.votes.count
    end
end
