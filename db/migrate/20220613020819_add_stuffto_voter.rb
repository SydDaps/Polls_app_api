class AddStufftoVoter < ActiveRecord::Migration[6.1]
  def change
    add_column :voters, :password_digest, :string
  end
end
