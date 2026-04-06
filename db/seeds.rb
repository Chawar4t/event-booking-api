# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Event.create!([
  {
    name: "BNK48",
    date: "2026-05-10 18:00:00",
    capacity: 200
  },
  {
    name: "Purpeech",
    date: "2026-06-20 17:00:00",
    capacity: 200
  },
  {
    name: "Folk Festival",
    date: "2026-07-15 19:00:00",
    capacity: 500
  },
  {
    name: "Sompong Band",
    date: "2026-07-20 21:00:00",
    capacity: 100
  }
])

puts "Created #{Event.count} events"