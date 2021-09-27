class AddIdToVoters < ActiveRecord::Migration[6.1]
  def change
    add_column :voters, :index_number, :string
  end
end
