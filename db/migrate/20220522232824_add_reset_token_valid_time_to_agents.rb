class AddResetTokenValidTimeToAgents < ActiveRecord::Migration[6.1]
  def change
    add_column :agents, :reset_token_valid_time, :datetime
  end
end
