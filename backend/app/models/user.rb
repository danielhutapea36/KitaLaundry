class User < ApplicationRecord
  has_secure_password

  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :restrict_with_error

  enum :role, {
    customer: 0,
    admin: 1,
    branch_manager: 2,
    support_agent: 3,
    center_admin: 4
  }, default: :customer

  validates :email, presence: true, uniqueness: true

  before_create :generate_verification_token

  def generate_verification_token
    self.verification_token = SecureRandom.urlsafe_base64.to_s
  end
end
