class CreateSections < ActiveRecord::Migration[6.1]
  def change
    create_table :sections, id: :uuid do |t|
      t.belongs_to :poll, type: :uuid, foreign_key: true
      t.string :description
      t.timestamps
    end
  end
end
