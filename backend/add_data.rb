branches = Branch.all

puts "Creating 10 staff for each branch..."
branches.each do |branch|
  10.times do |i|
    role = ['staff', 'washer', 'ironer', 'driver'].sample
    User.create!(
      first_name: "Staff #{role.capitalize} #{i+1}",
      last_name: branch.name,
      email: "staff_#{branch.id}_#{i+1}@kitalaundry.com",
      password: "password123",
      password_confirmation: "password123",
      phone: "0812#{rand(10000000..99999999)}",
      role: role,
      branch_id: branch.id
    ) rescue nil
  end
end

puts "Creating 10 inventory items for Center Admin..."
center_branch = Branch.first # assuming first branch is center or we just create it for center_admin
10.times do |i|
  InventoryItem.create!(
    name: "Deterjen Premium V#{i+1}",
    category: "Bahan Habis Pakai",
    quantity: rand(10..100),
    unit: "Liter",
    branch_id: center_branch.id,
    minimum_stock: 5
  ) rescue nil
end

puts "Done!"
