names = [
  "Budi Santoso", "Siti Aminah", "Ahmad Fauzi", "Dewi Lestari", "Rudi Hermawan",
  "Rina Wati", "Andi Saputra", "Maya Sari", "Hendra Gunawan", "Nina Marlina",
  "Dimas Anggara", "Eka Putri", "Fajar Sidiq", "Gita Gutawa", "Hasan Basri",
  "Intan Nuraini", "Joko Widodo", "Kiki Amalia", "Lina Marlina", "Mamat Alkatiri",
  "Nadia Vega", "Okan Kornelius", "Putri Titian", "Qory Sandioriva", "Reza Rahadian",
  "Sule Sutisna", "Tora Sudiro", "Udin Sedunia", "Vino Bastian", "Wulan Guritno",
  "Xena Xaverius", "Yayan Ruhian", "Zaskia Gotik", "Agung Hercules", "Bambang Pamungkas",
  "Cinta Laura", "Deddy Corbuzier", "Eko Patrio", "Fitri Tropica", "Gading Marten",
  "Hesti Purwadinata", "Irfan Hakim", "Jessica Iskandar", "Kaesang Pangarep", "Luna Maya",
  "Maudy Ayunda", "Nia Ramadhani", "Omesh", "Prilly Latuconsina", "Raffi Ahmad"
]

User.where(role: 'staff').each_with_index do |staff, index|
  staff.update(first_name: names[index % names.length], last_name: "")
end
puts "Updated staff names"
