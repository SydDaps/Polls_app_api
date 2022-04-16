class AddPublishMediumToPolls < ActiveRecord::Migration[6.1]
  def change
    add_column :polls, :publishing_medium, :string, :default => Poll::PublishMedium::EMAIL
    Poll.update_all(publishing_medium: Poll::PublishMedium::EMAIL)
  end
end
