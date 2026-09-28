class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.references :reporter, null: false, foreign_key: { to_table: :users }
      t.references :reported_user, null: false, foreign_key: { to_table: :users }
      t.references :post, null: true, foreign_key: true
      t.string :reason, null: false
      t.text :detail
      t.string :status, default: "pending", null: false

      t.timestamps
    end
  end
end
