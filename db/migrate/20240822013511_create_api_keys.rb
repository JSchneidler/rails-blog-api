class CreateApiKeys < ActiveRecord::Migration[7.2]
  def change
    create_table :api_keys do |t|
      t.references :user, null: false, foreign_key: true

      t.string :token_digest, null: false

      t.datetime :created_at, null: false
    end

    add_index :api_keys, :token_digest, unique: true
  end
end
