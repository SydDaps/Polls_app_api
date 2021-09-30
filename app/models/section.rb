class Section < ApplicationRecord
    belongs_to :poll
    has_many :options, dependent: :destroy
    has_many :votes, dependent: :destroy

    def total_votes
        self.votes.count
    end
end
