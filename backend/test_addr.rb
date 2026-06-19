user = User.first
addr = user.addresses.build(address_line_1: 'Jln Menteng VII', city: 'Medan', pincode: '20228')
puts "Is valid? #{addr.valid?}"
puts addr.errors.full_messages
