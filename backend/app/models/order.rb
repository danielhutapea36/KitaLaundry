class Order < ApplicationRecord
  belongs_to :user
  belongs_to :branch
  belongs_to :pickup_address, class_name: 'Address', optional: true
  belongs_to :delivery_address, class_name: 'Address', optional: true

  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items

  enum :status, { pending: 0, processing: 1, ready: 2, completed: 3, cancelled: 4 }
  enum :payment_status, { unpaid: 0, paid: 1, failed: 2, expired: 3 }

  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
end
