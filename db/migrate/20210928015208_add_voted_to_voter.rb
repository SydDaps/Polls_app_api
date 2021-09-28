class AddVotedToVoter < ActiveRecord::Migration[6.1]
  def change
    add_column :voters, :voted, :boolean
  end
end
