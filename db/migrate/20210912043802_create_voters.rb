class CreateVoters < ActiveRecord::Migration[6.1]
  def change
    create_table :voters, id: :uuid do |t|
      t.references :poll, type: :uuid, null: false, foreign_key: true
      t.string :email

      t.timestamps
    end
  end
end
