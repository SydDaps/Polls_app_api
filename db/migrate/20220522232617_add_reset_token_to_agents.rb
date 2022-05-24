class AddResetTokenToAgents < ActiveRecord::Migration[6.1]
  def change
    add_column :agents, :reset_token, :string
  end
end
