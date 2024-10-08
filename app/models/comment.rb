class Comment < ApplicationRecord
    belongs_to :user, class_name: "User", foreign_key: "author_id"
    belongs_to :article

    validates :body, presence: true
end
