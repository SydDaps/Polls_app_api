class CreateOrganizers < ActiveRecord::Migration[6.1]
  def change
    create_table :organizers, id: :uuid do |t|
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
