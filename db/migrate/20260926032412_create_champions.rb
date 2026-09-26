class CreateChampions < ActiveRecord::Migration[8.1]
  def change
    create_table :champions do |t|
      t.date :day, null: false
      t.string :champion_name
      t.integer :champion_points
      t.string :best_predictor_name
      t.integer :best_predictor_correct
      t.string :fastest_mate_winner
      t.integer :fastest_mate_moves
      t.integer :longest_game_moves
      t.integer :games_count, null: false, default: 0
      t.integer :players_count, null: false, default: 0

      t.timestamps
    end
    add_index :champions, :day, unique: true
  end
end
