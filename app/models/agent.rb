class Agent < ApplicationRecord
  has_and_belongs_to_many :polls, dependent: :destroy
  has_many :voters, dependent: :destroy

  has_secure_password :validations => false
  validates :name, presence: true
  validates :email, presence: true

  def type
    "Agent"
  end
end
