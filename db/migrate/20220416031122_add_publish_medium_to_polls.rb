class AddPublishMediumToPolls < ActiveRecord::Migration[6.1]
  def change
    add_column :polls, :publishing_medium, :string, :default => Poll::PublishingMedium::EMAIL
    Poll.update_all(publishing_medium: Poll::PublishingMedium::EMAIL)
  end
end
