class ChangeColumn < ActiveRecord::Migration[6.1]
  def change
    change_column_default :onboardings, :has_voted, false
  end
end
