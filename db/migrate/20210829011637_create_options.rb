class CreateOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :options, id: :uuid do |t|
      t.belongs_to :section, type: :uuid, foreign_key: true
      t.string :description
      t.string :image_url
      t.timestamps
    end
  end
end
