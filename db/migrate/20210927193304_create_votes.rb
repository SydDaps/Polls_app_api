class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes, id: :uuid do |t|
      t.belongs_to :poll, type: :uuid, foreign_key: true
      t.belongs_to :option, type: :uuid, foreign_key: true
      t.belongs_to :section, type: :uuid, foreign_key: true
      t.belongs_to :voter, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
