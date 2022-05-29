class Poll < ApplicationRecord

  module PublishedStatus
    PUBLISHED = 'published'
    PUBLISHING = 'publishing'
  end

  module PublishingMedium
    SMS = 'sms'
    EMAIL = 'email'
  end

  belongs_to :organizer
  has_many :sections, dependent: :destroy
  has_many :voters, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_and_belongs_to_many :agents, dependent: :destroy

  validate :validate_publish_mediums
  validate :validate_meta


  def total_voters
      self.voters.count
  end

  def total_votes
      self.votes.count
  end

  def  status
      if Time.now < self.start_at
          "Not Started"
      elsif Time.now > self.end_at
          "Ended"
      else
          "In Progress"
      end
  end

  def validate_publish_mediums
    allowed_mediums = ["sms", "email"]
    if self.publish_mediums.any? { |pm| allowed_mediums.exclude?(pm)}
      errors.add(:publish_mediums, :invalid)
    end
  end

  def validate_meta
    if self.meta["sms_subject"].present?
      errors.add(:base, 'Sms subject must be above 11 characters') if self.meta["sms_subject"].length > 11
    end
  end
end
