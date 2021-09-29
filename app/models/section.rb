class Section < ApplicationRecord
    belongs_to :poll
    has_many :options, dependent: :destroy
    has_many :votes, dependent: :destroy
end
