class RemovePublishingMediumFromPoll < ActiveRecord::Migration[6.1]
  def change
    remove_column :polls, :publishing_medium
  end
end
