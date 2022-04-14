class AddColumnPhoneNumberToVoters < ActiveRecord::Migration[6.1]
  def change
    add_column :voters, :phone_number, :string
  end
end
