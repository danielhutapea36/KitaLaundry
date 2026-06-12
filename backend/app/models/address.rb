class Address < ApplicationRecord
  belongs_to :user

  validates :full_address, presence: true
end
