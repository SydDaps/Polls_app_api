class Organizer < ApplicationRecord

    has_many :polls
    
    has_secure_password
    validates :name, presence: true
    validates :email, presence: true
    validates :password_confirmation, presence: true
end
