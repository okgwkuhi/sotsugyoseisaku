class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user_a, null: false, foreign_key: { to_table: :users }
      t.references :user_b, null: false, foreign_key: { to_table: :users }
      t.datetime :matched_at, null: false

      t.timestamps
    end

    add_index :matches, [:post_id, :user_a_id, :user_b_id],
      unique: true, name: "index_matches_on_post_and_users"
  end
end
