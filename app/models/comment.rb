class Comment < ApplicationRecord
    belongs_to :user, class_name: "User", foreign_key: "author"
    belongs_to :article

    validates :text, presence: true
end
