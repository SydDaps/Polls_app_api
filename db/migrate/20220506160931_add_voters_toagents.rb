class AddVotersToagents < ActiveRecord::Migration[6.1]
  def change
    add_reference :voters, :agent, type: :uuid, foreign_key: true, null: true
    add_reference :voters, :organizer, type: :uuid, foreign_key: true, null: true
  end
end
