class AddPasswordSetToVoter < ActiveRecord::Migration[6.1]
  def change
    add_column :voters, :password_set, :boolean, default: false
  end
end
