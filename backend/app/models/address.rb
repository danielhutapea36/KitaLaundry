class Address < ApplicationRecord
  belongs_to :user

  validates :address_line_1, :city, :pincode, presence: true
end
