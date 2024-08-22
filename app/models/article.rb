class Article < ApplicationRecord
    belongs_to :user, class_name: "User", foreign_key: "author"
    has_many :comments, dependent: :destroy

    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 10 }
end
