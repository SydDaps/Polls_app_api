class AddSuperOption < ActiveRecord::Migration[6.1]
  def change
    add_reference :options, :super_option,type: :uuid, foreign_key: { to_table: :options }
  end
end
