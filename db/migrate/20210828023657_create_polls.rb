class CreatePolls < ActiveRecord::Migration[6.1]
  def change
    create_table :polls, id: :uuid do |t|
      t.string :title
      t.string :description
      t.datetime :start_at
      t.datetime :end_at
      t.belongs_to :organizer, type: :uuid, foreign_key: true

      t.timestamps
    end
  end
end
