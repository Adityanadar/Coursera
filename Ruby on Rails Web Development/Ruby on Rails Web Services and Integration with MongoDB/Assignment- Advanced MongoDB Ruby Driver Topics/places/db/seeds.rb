# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Photo.all.each {|photo| photo.destroy }

Place.collection.delete_many

if !Place.collection.indexes.map{|r| r[:name]}.include? "geometry.geolocation_2dsphere"
	Place.create_indexes
end

f = File.open("./db/places.json")
Place.load_all(f)

Dir.glob('./db/image*.jpg') do |f|
	photo = Photo.new
	photo.contents = File.open(f, 'rb')
	photo.save
end

Photo.all.each do |photo|
	place_id = photo.find_nearest_place_id(1*1609.34)
	photo.place = place_id
	photo.save
end