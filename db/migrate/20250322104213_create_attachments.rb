class CreateAttachments < ActiveRecord::Migration[7.0]
  def change
    create_table :attachments do |t|
      t.references :message, null: false, foreign_key: true
      t.integer :content_type, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.string :prompt
      t.string :url
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :attachments, [:message_id, :content_type]
    add_index :attachments, :status
  end
end
