# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Ranking.delete_all
# $redis.flushdb

rnd = Random.new(1234)

(1..10000).each do |i|

   user = { userid: i,
                  name: Faker::Name.name,
                  winpercentage: rnd.rand(0..1000)/10.0,
                  level: rnd.rand(0..99),
                  xp: rnd.rand(0..99999),
                  honor:rnd.rand(0..999),
                  military: rnd.rand(0..9999) }

   # SQL DB insert
   # Ranking.create user

   userid = user.delete(:userid)
   $redis.mapped_hmset(userid, user)
   Ranking::SORTKEYS.each do |key|
      $redis.zadd(key, user[key.to_sym], userid)
   end
end


# Ranking.create userid: 1, name: "David", winpercentage: 45.5, level: 10, xp: 4353, honor:3, military: 10000
#       Ranking.create userid: 2, name: "Rick", winpercentage: 56.5, level: 12, xp: 5353, honor:4, military: 60000
#       Ranking.create userid: 3, name: "Tim", winpercentage: 34.5, level: 1, xp: 6353, honor:8, military: 50000
#       Ranking.create userid: 4, name: "Utiwi", winpercentage: 10.5, level: 3, xp: 7353, honor:9, military: 40000
#       Ranking.create userid: 5, name: "Quangli", winpercentage: 100.0, level: 4, xp: 4353, honor:3, military: 10000
#       Ranking.create userid: 6, name: "Park", winpercentage: 77.5, level: 5, xp: 8353, honor:10, military: 30000
#       Ranking.create userid: 7, name: "Emmy", winpercentage: 1.5, level: 6, xp: 353, honor:11, military: 20000
#       Ranking.create userid: 8, name: "Bob", winpercentage: 66.5, level: 7, xp: 4953, honor:2, military: 19000
#       Ranking.create userid: 9, name: "Xlett", winpercentage: 33.5, level: 12, xp: 2353, honor:2, military: 11000
#       Ranking.create userid: 10, name: "Lena", winpercentage: 22.5, level: 15, xp: 1353, honor:0, military: 12000
#       Ranking.create userid: 11, name: "Shank", winpercentage: 11.5, level: 0, xp: 10353, honor:1, military: 13000
