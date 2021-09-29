class AddPassKeyToVoters < ActiveRecord::Migration[6.1]
  def change
    add_column :voters, :pass_key, :string
  end
end
