class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :email_address, presence: true, uniqueness: true
  has_secure_password
  has_many :sessions, dependent: :destroy
  validate :password, :password_must_be_different_from_current, if: -> { password_digest_was.present? }

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_destroy :ensure_an_admin_remains

  class Error < StandardError
  end

  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise Error.new "Can't delete last user"
      end
    end

    # ensure that the password will change
    def password_must_be_different_from_current
      if BCrypt::Password.new(password_digest_was) == password
        errors.add(:base, "Password must be different from current")
        throw :abort
      end
    end
end
