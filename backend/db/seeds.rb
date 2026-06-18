# Bersihkan data lama dengan urutan yang benar karena ada foreign keys
puts "Menghapus data lama..."
OrderItem.destroy_all
Order.destroy_all
Service.destroy_all
Address.destroy_all
Branch.destroy_all
User.destroy_all

puts "Membuat Cabang..."
# 5 Cabang di Medan
branches = [
  Branch.create!(
    name: "KitaLaundry Medan Petisah",
    address: "Jl. Gatot Subroto No. 45, Medan",
    phone: "08116000001",
    status: :active
  ),
  Branch.create!(
    name: "KitaLaundry Medan Baru",
    address: "Jl. Jamin Ginting No. 102, Medan",
    phone: "08116000002",
    status: :active
  ),
  Branch.create!(
    name: "KitaLaundry Medan Timur",
    address: "Jl. Krakatau No. 77, Medan",
    phone: "08116000003",
    status: :active
  ),
  Branch.create!(
    name: "KitaLaundry Medan Sunggal",
    address: "Jl. Setia Budi No. 200, Medan",
    phone: "08116000004",
    status: :active
  ),
  Branch.create!(
    name: "KitaLaundry Medan Johor",
    address: "Jl. Karya Wisata No. 50, Medan",
    phone: "08116000005",
    status: :active
  )
]

puts "Membuat Layanan (Services)..."
# Layanan untuk setiap cabang
service_templates = [
  { name: "Cuci Komplit (Reguler)", price: 7000, desc: "Cuci dan setrika pakaian reguler, selesai dalam 2-3 hari" },
  { name: "Cuci Kering", price: 5000, desc: "Hanya cuci kering dan lipat rapi, tidak disetrika" },
  { name: "Setrika Saja", price: 4000, desc: "Hanya jasa setrika pakaian yang sudah bersih" },
  { name: "Cuci Sepatu Premium", price: 35000, desc: "Perawatan cuci sepatu dengan sabun khusus dan sikat lembut" },
  { name: "Cuci Bedcover", price: 25000, desc: "Cuci bedcover segala ukuran (Harga per potong/estimasi per kg)" },
  { name: "Cuci Jas/Blazer", price: 20000, desc: "Pencucian jas formal atau blazer dengan metode dry clean ringan" }
]

all_services = []
branches.each do |branch|
  service_templates.each do |st|
    all_services << Service.create!(
      branch: branch,
      name: st[:name],
      price_per_kg: st[:price],
      description: st[:desc]
    )
  end
end

puts "Membuat User (Admin, Managers, Customers)..."
# Admin Pusat
admin = User.create!(
  email: "admin@kitalaundry.com",
  password: "password123",
  role: :center_admin,
  first_name: "Admin",
  last_name: "Pusat",
  phone: "08111222333",
  email_verified_at: Time.current
)

# 5 Branch Managers
managers = []
branches.each_with_index do |branch, index|
  name_parts = branch.name.split(' ')
  managers << User.create!(
    email: "manager.#{name_parts.last.downcase}@kitalaundry.com",
    password: "password123",
    role: :branch_manager,
    first_name: "Manager",
    last_name: name_parts.last,
    phone: "0811600100#{index}",
    email_verified_at: Time.current
  )
end

# 15 Customers (3 per cabang)
customers = []
15.times do |i|
  customers << User.create!(
    email: "customer#{i+1}@gmail.com",
    password: "password123",
    role: :customer,
    first_name: "Pelanggan",
    last_name: "Ke-#{i+1}",
    phone: "08999888#{i.to_s.rjust(3, '0')}",
    email_verified_at: Time.current
  )
end

puts "Membuat Alamat Pelanggan..."
cities = ["Medan Petisah", "Medan Baru", "Medan Timur", "Medan Sunggal", "Medan Johor"]
customers.each_with_index do |customer, i|
  # Default Address (Home)
  Address.create!(
    user: customer,
    address_type: "home",
    address_line_1: "Jl. Perumahan Indah No. #{i+10}",
    address_line_2: "Blok A#{i}",
    city: cities[i % 5],
    state: "Sumatera Utara",
    pincode: "2011#{i % 5}",
    landmark: "Dekat Mesjid/Gereja",
    phone: customer.phone,
    is_default: true
  )

  # Secondary Address (Office)
  if i % 2 == 0
    Address.create!(
      user: customer,
      address_type: "office",
      address_line_1: "Gedung Perkantoran Maju Lt. #{i % 5 + 1}",
      city: "Medan Pusat",
      state: "Sumatera Utara",
      pincode: "20111",
      phone: customer.phone,
      is_default: false
    )
  end
end

puts "Membuat Order & Transaksi..."
payment_methods = ['cash', 'qris', 'bank_transfer', 'ewallet']
order_statuses = [0, 1, 2, 3, 4] # :pending, :processing, :ready_for_delivery, :completed, :cancelled
payment_statuses = [0, 1, 2] # :unpaid, :paid, :failed

# Membuat total 45 orderan (rata-rata 3 order per pelanggan)
customers.each_with_index do |customer, idx|
  # Pilih cabang yang lokasinya sesuai dengan kota pelanggan (index branch sama dengan index city mod 5)
  branch = branches[idx % 5]
  branch_services = branch.services.to_a
  address = customer.addresses.first

  3.times do |o_idx|
    status = order_statuses.sample
    # Jika sudah diproses, kemungkinan besar sudah dibayar
    payment_status = (status >= 1) ? 1 : payment_statuses.sample
    
    order = Order.create!(
      user: customer,
      branch: branch,
      pickup_address_id: address.id,
      delivery_address_id: address.id,
      status: status,
      payment_status: payment_status,
      payment_method: payment_methods.sample,
      notes: "Tolong lipat yang rapi ya.",
      created_at: rand(1..30).days.ago
    )

    # Tambahkan 1 atau 2 item layanan ke dalam order
    total_price = 0
    rand(1..2).times do
      service = branch_services.sample
      weight = rand(2.0..6.5).round(1)
      
      OrderItem.create!(
        order: order,
        service: service,
        weight_kg: weight
      )
      total_price += (service.price_per_kg * weight).to_i
    end

    # Update total price order
    order.update(total_price: total_price)
  end
end

puts "✅ Seeding selesai dengan sempurna!"
puts "--------------------------------------------------"
puts "🔑 Gunakan kredensial berikut untuk login/testing:"
puts "--- ADMIN PUSAT ---"
puts "Email: admin@kitalaundry.com | Pass: password123"
puts "--- BRANCH MANAGERS ---"
managers.each do |m|
  puts "Email: #{m.email} | Pass: password123 | (Cabang #{m.last_name})"
end
puts "--- CUSTOMERS ---"
puts "Email: customer1@gmail.com s/d customer15@gmail.com | Pass: password123"
puts "--------------------------------------------------"
