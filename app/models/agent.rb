class Agent < ApplicationRecord
  belongs_to :poll
  has_many :voters, dependent: :destroy

  has_secure_password :validations => false
  validates :name, presence: true
  validates :email, presence: true
end
