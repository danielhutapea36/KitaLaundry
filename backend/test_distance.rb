controller = DeliveryController.new

branch_address = "Jl. Gatot Subroto No. 45, Medan"
pickup_address_str = "Jalan Sampul, Sei Putih Barat, Kota Medan"

puts "Testing Geocode Branch:"
branch_coords = controller.send(:geocode, branch_address)
puts branch_coords.inspect

puts "Testing Geocode Pickup:"
pickup_coords = controller.send(:geocode, pickup_address_str)
puts pickup_coords.inspect

if branch_coords && pickup_coords
  puts "Testing OSRM Distance:"
  dist = controller.send(:calculate_osrm_distance, branch_coords, pickup_coords)
  puts dist.inspect
else
  puts "Geocode failed, skipping OSRM"
end
