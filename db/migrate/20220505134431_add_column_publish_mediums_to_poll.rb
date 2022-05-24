class AddColumnPublishMediumsToPoll < ActiveRecord::Migration[6.1]
  def change
    add_column :polls, :publish_mediums, :string, array: true , default: []
  end
end
