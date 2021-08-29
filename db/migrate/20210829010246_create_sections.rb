class CreateSections < ActiveRecord::Migration[6.1]
  def change
    create_table :sections do |t|
      t.belongs_to :poll, foreign_key: true
      t.string :description
      t.timestamps
    end
  end
end
