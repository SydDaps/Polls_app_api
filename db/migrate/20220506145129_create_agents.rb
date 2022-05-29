class CreateAgents < ActiveRecord::Migration[6.1]
  def change
    create_table :agents, id: :uuid do |t|
      t.string :email
      t.string :name
      t.string :phone_number
      t.string :password_digest
      t.timestamps
    end
  end
end
