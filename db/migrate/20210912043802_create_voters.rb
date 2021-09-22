class CreateVoters < ActiveRecord::Migration[6.1]
  def change
    create_table :voters do |t|
      t.references :poll, null: false, foreign_key: true
      t.string :email

      t.timestamps
    end
  end
end
