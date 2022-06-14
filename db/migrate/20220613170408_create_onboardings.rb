class CreateOnboardings < ActiveRecord::Migration[6.1]
  def change
    create_table :onboardings, id: :uuid do |t|
      t.belongs_to :poll, type: :uuid, foreign_key: true
      t.belongs_to :agent, type: :uuid, foreign_key: true
      t.belongs_to :voter, type: :uuid, foreign_key: true
      t.belongs_to :organizer, type: :uuid, foreign_key: true
      t.string :index_number
      t.boolean :has_voted
      t.timestamps
    end
  end
end
