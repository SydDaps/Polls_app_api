class Voter < ApplicationRecord
  belongs_to :poll
  has_many :votes, dependent: :destroy
  belongs_to :organizer, optional: true
  belongs_to :agent, optional: true

  validates :email, presence: true, unless: :phone_number
  validates :phone_number, presence: true, unless: :email
  validates :organizer_id, presence: true, unless: :agent
  validates :agent_id, presence: true, unless: :organizer
end
