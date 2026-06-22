require_relative 'config/environment'

user = User.find_by(email: "admin@kitalaundry.com")
token = JsonWebToken.encode(user_id: user.id)

env = Rack::MockRequest.env_for(
  "/admin/users",
  "HTTP_AUTHORIZATION" => "Bearer #{token}",
  "REQUEST_METHOD" => "GET"
)

status, headers, body = Rails.application.call(env)
puts "STATUS: #{status}"
puts "BODY: #{body.join}"
