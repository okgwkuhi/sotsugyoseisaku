class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string   :title, null: false
      t.string   :game_name, null: false
      t.datetime :event_at, null: false
      t.string   :area, null: false
      t.string   :meeting_place
      t.integer  :capacity, null: false
      t.string   :style, null: false
      t.string   :level, default: "誰でも歓迎"
      t.string   :status, default: "open"
      t.text     :description

      t.timestamps
    end

    add_index :posts, :event_at
    add_index :posts, :game_name
    add_index :posts, :style
  end
end
