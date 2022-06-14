class Voter < ApplicationRecord
  # has_and_belongs_to_many :polls, dependent: :destroy
  has_secure_password :validations => false

  has_many :votes, dependent: :destroy
  belongs_to :organizer, optional: true
  belongs_to :agent, optional: true

  validates :email, presence: true, unless: :phone_number
  validates :phone_number, presence: true, unless: :email

  has_many :onboardings
  has_many :polls, through: :onboardings

end
