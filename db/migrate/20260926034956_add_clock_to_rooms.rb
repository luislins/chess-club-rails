class AddClockToRooms < ActiveRecord::Migration[8.1]
  def change
    add_column :rooms, :time_control, :integer, null: false, default: 600 # seconds per side
    add_column :rooms, :white_ms, :integer
    add_column :rooms, :black_ms, :integer
    add_column :rooms, :turn_started_at, :datetime
  end
end
