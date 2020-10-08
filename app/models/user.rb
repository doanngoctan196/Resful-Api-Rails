class User < ApplicationRecord
    has_secure_password
    acts_as_paranoid
    has_many :posts, dependent: :destroy
    has_many :comments, as: :commentable,  dependent: :destroy
end
