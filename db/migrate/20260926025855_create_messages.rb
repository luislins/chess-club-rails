class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.references :room, null: false, foreign_key: true
      t.string :nickname, null: false
      t.string :body, null: false, limit: 300

      t.timestamps
    end
  end
end
