class CreateRooms < ActiveRecord::Migration[8.1]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :status, null: false, default: "waiting"
      t.string :creator_token, null: false
      t.string :white_token
      t.string :black_token
      t.string :white_name
      t.string :black_name
      t.text :moves, null: false, default: "[]"
      t.string :result
      t.datetime :last_activity_at, null: false

      t.timestamps
    end
    add_index :rooms, :slug, unique: true
    add_index :rooms, :status
    add_index :rooms, :creator_token
    add_index :rooms, :last_activity_at
  end
end
