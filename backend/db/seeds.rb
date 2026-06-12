# Bersihkan data lama
User.destroy_all
Branch.destroy_all

# Buat Cabang
branches = [
  Branch.create!(
    name: "KitaLaundry Pusat",
    address: "Jl. Sudirman No. 1, Jakarta",
    phone: "08123456789",
    status: :active
  ),
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

# Buat Layanan (Services)
branches.each do |branch|
  Service.create!(
    branch: branch,
    name: "Cuci Komplit (Reguler)",
    price_per_kg: 7000,
    description: "Cuci dan setrika, selesai dalam 2-3 hari"
  )

  Service.create!(
    branch: branch,
    name: "Cuci Kering",
    price_per_kg: 5000,
    description: "Hanya cuci kering, tidak disetrika"
  )
end

# Buat User Admin
admin = User.create!(
  email: "admin@kitalaundry.com",
  password: "password123",
  role: :center_admin,
  first_name: "Admin",
  last_name: "Pusat",
  phone: "08111222333"
)

# Buat User Customer
customer = User.create!(
  email: "customer@gmail.com",
  password: "password123",
  role: :customer,
  first_name: "Budi",
  last_name: "Santoso",
  phone: "08999888777"
)

puts "✅ Seeding selesai!"
puts "--------------------------------------------------"
puts "🔑 Gunakan kredensial berikut untuk login/testing:"
puts "Admin    : admin@kitalaundry.com    | password: password123"
puts "Customer : customer@gmail.com       | password: password123"
puts "--------------------------------------------------"
