class AddSettingsToPolls < ActiveRecord::Migration[6.1]
  def change
    add_column :polls, :meta, :jsonb, default: {}
  end
end