# One row per finished game. Rooms are deleted after a while, games are kept
# for the ranking, the daily recap and the hall of fame.
class CreateGames < ActiveRecord::Migration[8.1]
  def change
    create_table :games do |t|
      t.date :day, null: false
      t.integer :room_id
      t.string :room_name, null: false
      t.string :theme_key, null: false, default: "classic"
      t.references :white_player, foreign_key: { to_table: :players }
      t.references :black_player, foreign_key: { to_table: :players }
      t.string :result, null: false
      t.integer :moves_count, null: false, default: 0
      t.boolean :counted, null: false, default: false

      t.timestamps
    end
    add_index :games, [ :day, :counted ]
  end
end
