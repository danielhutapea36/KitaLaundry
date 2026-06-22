require 'net/http'

token = JsonWebToken.encode(user_id: User.find_by(email: "admin@kitalaundry.com").id)
uri = URI('http://localhost:8000/admin/users?role=staff')
req = Net::HTTP::Get.new(uri)
req['Authorization'] = "Bearer #{token}"
res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
puts "CODE: #{res.code}"
puts "BODY: #{res.body[0..100]}"
