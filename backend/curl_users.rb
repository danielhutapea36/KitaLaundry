require 'net/http'
require 'uri'
require 'json'

token = JsonWebToken.encode(user_id: User.find_by(email: "admin@kitalaundry.com").id)
uri = URI.parse("http://localhost:8000/admin/users")
request = Net::HTTP::Get.new(uri)
request["Authorization"] = "Bearer #{token}"

response = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(request)
end

puts response.code
begin
  puts JSON.parse(response.body)["exception"]
rescue
  puts response.body
end
