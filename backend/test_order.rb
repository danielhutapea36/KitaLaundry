user = User.last
pickup = user.addresses.first
delivery = user.addresses.first
branch = Branch.first

order = Order.new(
  user: user,
  branch_id: branch.id,
  pickup_address_id: pickup.id,
  delivery_address_id: delivery.id,
  notes: 'tes pickup',
  payment_method: 'online',
  total_price: 30800,
  payment_status: :unpaid
)

service = Service.find_by(branch_id: branch.id) || Service.first
order.order_items.build(service: service, weight_kg: 1)

puts "Valid? #{order.valid?}"
puts order.errors.full_messages
