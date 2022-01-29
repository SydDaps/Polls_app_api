class AddPublishedStatusToPolls < ActiveRecord::Migration[6.1]
  def change
    add_column :polls, :publish_status, :string
  end
end
