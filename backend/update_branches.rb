updates = {
  "KitaLaundry Medan Petisah" => { name: "KitaLaundry Medan Petisah", address: "Plaza Medan Fair, Kota Medan" },
  "KitaLaundry Medan Baru" => { name: "KitaLaundry Medan Polonia", address: "Sun Plaza, Kota Medan" },
  "KitaLaundry Medan Timur" => { name: "KitaLaundry Medan Timur", address: "Centre Point Mall, Kota Medan" },
  "KitaLaundry Medan Sunggal" => { name: "KitaLaundry Medan Sunggal", address: "Manhattan Times Square, Kota Medan" },
  "KitaLaundry Medan Johor" => { name: "KitaLaundry Medan Johor", address: "Jalan Karya Wisata, Medan Johor, Kota Medan" }
}

Branch.find_each do |branch|
  if updates[branch.name]
    branch.update!(updates[branch.name])
    puts "Updated: #{branch.name} -> #{branch.address}"
  end
end
