class Poll < ApplicationRecord
    belongs_to :organizer
    has_many :sections, dependent: :destroy
    has_many :voters, dependent: :destroy
    has_many :votes, dependent: :destroy
end
