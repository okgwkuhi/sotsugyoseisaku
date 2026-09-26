class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text   :comment
      t.string :status, default: "pending"

      t.timestamps
    end

    add_index :applications, [:post_id, :user_id], unique: true
  end
end
