class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :article, null: false, foreign_key: true

      t.text :body, null: false

      t.timestamps null: false
    end
  end
end
