class CreateAgentsPolls < ActiveRecord::Migration[6.1]
  def change
    create_table :agents_polls, id: :uuid do |t|
      t.belongs_to :agent, type: :uuid, foreign_key: true
      t.belongs_to :poll, type: :uuid, foreign_key: true
      t.timestamps
    end
  end
end
