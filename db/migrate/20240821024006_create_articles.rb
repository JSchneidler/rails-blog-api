class CreateArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :articles do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }

      t.string :title, null: false
      t.text :body, null: false

      t.timestamps null: false
    end
  end
end
