class CreatePlayers < ActiveRecord::Migration[8.1]
  def change
    create_table :players do |t|
      t.date :day, null: false
      t.string :token, null: false
      t.string :name, null: false
      t.integer :points, null: false, default: 0
      t.integer :wins, null: false, default: 0
      t.integer :draws, null: false, default: 0
      t.integer :losses, null: false, default: 0
      t.integer :streak, null: false, default: 0
      t.integer :predictions_correct, null: false, default: 0
      t.integer :predictions_total, null: false, default: 0

      t.timestamps
    end
    add_index :players, [ :day, :token ], unique: true
    add_index :players, "day, lower(name)", unique: true, name: "index_players_on_day_and_lower_name"
    add_index :players, [ :day, :points ]
  end
end
