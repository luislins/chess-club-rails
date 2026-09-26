class CreatePredictions < ActiveRecord::Migration[8.1]
  def change
    create_table :predictions do |t|
      t.references :room, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.string :color, null: false

      t.timestamps
    end
    add_index :predictions, [ :room_id, :player_id ], unique: true
  end
end
