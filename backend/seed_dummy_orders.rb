puts "Menghapus histori pesanan dan alamat..."
OrderItem.destroy_all
Order.destroy_all
Address.destroy_all

real_addresses = [
  { line1: "Jalan Sisingamangaraja", city: "Kota Medan", type: "Rumah" },
  { line1: "Jalan Brigjend Katamso", city: "Kota Medan", type: "Kantor" },
  { line1: "Jalan Jamin Ginting", city: "Kota Medan", type: "Rumah" },
  { line1: "Jalan Pemuda", city: "Kota Medan", type: "Rumah" },
  { line1: "Jalan Ahmad Yani", city: "Kota Medan", type: "Kantor" },
  { line1: "Jalan MT Haryono", city: "Kota Medan", type: "Rumah" },
  { line1: "Jalan Thamrin", city: "Kota Medan", type: "Kantor" },
  { line1: "Jalan Asia", city: "Kota Medan", type: "Rumah" },
  { line1: "Jalan Cemara", city: "Kota Medan", type: "Rumah" },
  { line1: "Jalan Pancing", city: "Kota Medan", type: "Kantor" },
  { line1: "Jalan Ringroad", city: "Kota Medan", type: "Rumah" },
  { line1: "Jalan Setia Budi", city: "Kota Medan", type: "Rumah" },
  { line1: "Jalan Dr. Mansyur", city: "Kota Medan", type: "Kantor" }
]

customers = User.where(role: :customer)
branches = Branch.all.to_a
service_items = ServiceItem.all.to_a

puts "Membuat alamat dan pesanan baru untuk #{customers.count} pelanggan..."

customers.each do |customer|
  # Buat 2 alamat berbeda untuk tiap user
  user_addresses = []
  2.times do
    addr_data = real_addresses.sample
    user_addresses << customer.addresses.create!(
      address_line_1: addr_data[:line1],
      city: addr_data[:city],
      pincode: "20" + rand(100..200).to_s,
      address_type: addr_data[:type],
      full_address: "#{addr_data[:line1]}, #{addr_data[:city]}",
      is_default: user_addresses.empty?
    )
  end

  # Buat 10 pesanan dengan cabang berbeda
  10.times do |i|
    branch = branches.sample
    addr = user_addresses.sample
    
    # 5 hari ke belakang hingga hari ini secara acak
    past_date = rand(0..5).days.ago - rand(0..23).hours

    # Status pesanan secara acak, tapi pastikan sebagian selesai
    statuses = [:pending, :processing, :completed, :completed, :completed]
    
    order = Order.new(
      user: customer,
      branch: branch,
      pickup_address_id: addr.id,
      delivery_address_id: addr.id,
      payment_method: ['cod', 'online'].sample,
      status: statuses.sample,
      created_at: past_date,
      updated_at: past_date
    )
    
    # Isi dengan 1-3 service items
    subtotal = 0
    rand(1..3).times do
      si = service_items.sample
      s = Service.find_by(category: si.category) || Service.first
      qty = rand(1..5)
      
      order.order_items.build(
        service: s, 
        weight_kg: qty, 
        item_name: si.name, 
        unit_price: si.base_price
      )
      subtotal += (si.base_price * qty)
    end
    
    tax = (subtotal * 0.1).to_i
    delivery = 5000 + rand(0..10) * 1000
    order.total_price = subtotal + tax + delivery
    order.payment_status = order.payment_method == 'online' ? [:paid, :paid, :unpaid].sample : :unpaid
    
    order.save!
  end
end

puts "Selesai! Berhasil membuat #{Order.count} pesanan baru dan #{Address.count} alamat real."
