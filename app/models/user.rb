class User < ApplicationRecord
    has_secure_password
    acts_as_paranoid
    has_many :posts, dependent: :destroy
    has_many :comments, dependent: :destroy
end
