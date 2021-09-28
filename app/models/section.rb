class Section < ApplicationRecord
    belongs_to :poll
    has_many :options
    has_many :votes
end
