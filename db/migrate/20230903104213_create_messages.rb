class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.integer :role, null: false, default: 0
      t.string :content, null: false

      t.timestamps
    end
  end
end
