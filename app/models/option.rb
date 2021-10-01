class Option < ApplicationRecord
    belongs_to :section
    has_many :votes, dependent: :destroy

    def total_votes
        self.votes.count
    end
end
