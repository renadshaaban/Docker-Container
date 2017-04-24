# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


bugs= Bug.create([{application_token: "1234" , status:0, comment: "This is a comment", priority:"minor", state_id: 1},{application_token: "1234", number:2 , status:0, comment: "This is the second comment",priority: "critical", state_id: 1}])
states= State.create([{device: "iphone7", os:"IOS", memory: "1024", storage: "12800"},{device: "samsung7", os:"android", memory: "1024", storage: "12800"}])

