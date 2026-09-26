class AddThemeKeyToRooms < ActiveRecord::Migration[8.1]
  def change
    add_column :rooms, :theme_key, :string, null: false, default: "classic"
  end
end
