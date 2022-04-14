class Option < ApplicationRecord
    belongs_to :section
    has_many :votes, dependent: :destroy
    has_many :sub_options, class_name: "Option", foreign_key: "super_option_id", dependent: :destroy
    belongs_to :super_option, class_name: "Option", optional: true


    scope :are_super_options, -> { where(super_option_id: nil) }

    def total_votes
      self.votes.count
    end

    def has_sub_options?
      return self.sub_options.present?
    end
end
