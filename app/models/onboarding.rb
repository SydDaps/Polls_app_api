class Onboarding < ApplicationRecord
  belongs_to :agent, optional: true
  belongs_to :voter
  belongs_to :organizer, optional: true
  belongs_to :poll

  validates :organizer_id, presence: true, unless: :agent
  validates :agent_id, presence: true, unless: :organizer
end
