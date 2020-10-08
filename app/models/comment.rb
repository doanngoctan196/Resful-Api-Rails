class Comment < ApplicationRecord
    acts_as_paranoid
    belongs_to :user
    belongs_to :post
    belongs_to :commentable, polymorphic: true
    has_many :comments, as: :commentable
end
