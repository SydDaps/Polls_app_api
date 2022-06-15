class RemovePollIdFromPolls < ActiveRecord::Migration[6.1]
  def change
    remove_column :voters, :poll_id, :uuid
  end
end
