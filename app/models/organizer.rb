class Organizer < ApplicationRecord

    has_many :polls
    has_many :voters, dependent: :destroy

    has_secure_password
    validates :name, presence: true
    validates :email, presence: true
    validates :password_confirmation, presence: true

    def type
      "Organizer"
    end
end
