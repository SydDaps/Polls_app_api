class Option < ApplicationRecord
    belongs_to :section
    has_many :votes
end
