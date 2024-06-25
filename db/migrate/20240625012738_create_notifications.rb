# db/migrate/YYYYMMDDHHMMSS_create_notifications.rb
class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sender, foreign_key: { to_table: :users }
      t.integer :receiver_id
      t.string :receiver_type
      t.references :company, foreign_key: true # Add if notifications are company-specific
      t.string :message
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
