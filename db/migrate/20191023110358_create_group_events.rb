class CreateGroupEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :group_events do |t|
      t.belongs_to :creator, null: false, foreign_key: { to_table: :users }
      t.date :start_date
      t.date :end_date
      t.string :name
      t.text :description
      t.boolean :published, default: false
      t.string :location
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :group_events, :discarded_at
  end
end
