class UserAddition < ActiveRecord::Migration[6.1]
  def change
    add_column :organizers, :reset_token, :string
    add_column :organizers, :reset_token_valid_time, :datetime
  end
end
