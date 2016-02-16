class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :sender
      t.string :from
      t.string :subject
      t.text :stripped_text
      t.text :body_plain
      t.text :stripped_html
      t.text :body_html

      t.timestamps null: false
    end
  end
end
