class User < ApplicationRecord
    has_secure_password
    validates :name, :password_digest, :email, :contact, presence: true
    validates :email, uniqueness: true
end
