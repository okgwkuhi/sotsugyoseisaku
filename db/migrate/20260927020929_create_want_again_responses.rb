class CreateWantAgainResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :want_again_responses do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :target_user, null: false, foreign_key: { to_table: :users }
      t.boolean :wants_again, null: false

      t.timestamps
    end

    add_index :want_again_responses, [:post_id, :user_id, :target_user_id],
      unique: true, name: "index_war_on_post_user_target"
  end
end
