class AddStrippedSignatureToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :stripped_signature, :text
  end
end
