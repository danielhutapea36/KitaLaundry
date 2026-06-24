require 'net/http'
puts app.get("/services/time_slots")
puts app.response.body
