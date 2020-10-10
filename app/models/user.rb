class User < ApplicationRecord
    has_secure_password
    # validates :name, :password_digest,:email, :contact, presence: true
    # validates_uniqueness_of :email
end
