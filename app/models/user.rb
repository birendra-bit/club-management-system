class User < ApplicationRecord
    validates :name, :password_digest,:email, :contact, presence: true
    validates_uniqueness_of :email, :contact
    has_secure_password
end
