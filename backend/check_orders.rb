puts Order.where(user_id: nil).count
puts Order.all.any? { |o| o.user.nil? }
