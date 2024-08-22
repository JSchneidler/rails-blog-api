class User < ApplicationRecord
  has_many :api_keys, dependent: :destroy

  has_many :articles, foreign_key: "author_id", dependent: :destroy
  has_many :comments, foreign_key: "author_id", dependent: :destroy

  validates :name, presence: true, uniqueness: true

  has_secure_password
end
