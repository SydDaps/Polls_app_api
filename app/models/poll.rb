class Poll < ApplicationRecord
    belongs_to :organizer
    has_many :sections
    has_many :voters
end
