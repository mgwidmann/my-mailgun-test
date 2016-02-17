class AddUniqueIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :unique_id, :string
  end
end
