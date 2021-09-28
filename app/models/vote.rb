class Vote < ApplicationRecord
    belongs_to :poll
    belongs_to :section
    belongs_to :option
    belongs_to :voter
end
