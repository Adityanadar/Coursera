class Place	
	include ActiveModel::Model

	attr_accessor :id, :formatted_address, :location, :address_components

	def self.mongo_client
		Mongoid::Clients.default
	end

	def self.collection
		mongo_client[:places]
	end

	def self.load_all(data)
		if data.is_a?(File)
			hash = JSON.parse(data.read)
			collection.insert_many(hash)		
		else
			puts 'Input data must be of type File'
		end
	end

	def self.find_by_short_name short_name
		collection.find("address_components.short_name" => short_name)
	end
	
	def self.to_places place_collection
		place_collection.map {|element| Place.new(element)}
	end
	
	def self.find id
		result = collection.find(:_id => BSON::ObjectId.from_string(id)).first
		Place.new(result) if !result.nil?
	end
	
	def self.all(offset=0, limit=nil)
		if !limit.nil?
			collection.find.skip(offset).limit(limit).map {|result| Place.new(result)}
		else
			collection.find.skip(offset).map {|result| Place.new(result)}
		end
	end

	def self.get_address_components(sort=nil, offset=0, limit=nil)	
		if sort.nil? && limit.nil?
			Place.collection.aggregate([
			{:$unwind => '$address_components'},
			{:$project => {:_id => 1, :address_components => 1, :formatted_address => 1, :geometry => {:geolocation => 1}}},
			{:$skip => offset}
			])
		elsif sort.nil? && !limit.nil?
			Place.collection.aggregate([
			{:$unwind => '$address_components'},
			{:$project => {:_id => 1, :address_components => 1, :formatted_address => 1, :geometry => {:geolocation => 1}}},
			{:$skip => offset},
			{:$limit => limit}
			])
		elsif !sort.nil? && limit.nil?
			Place.collection.aggregate([
			{:$unwind => '$address_components'},
			{:$project => {:_id => 1, :address_components => 1, :formatted_address => 1, :geometry => {:geolocation => 1}}},
			{:$sort => sort},
			{:$skip => offset}
			])
		else
			Place.collection.aggregate([
			{:$unwind => '$address_components'},
			{:$project => {:_id => 1, :address_components => 1, :formatted_address => 1, :geometry => {:geolocation => 1}}},
			{:$sort => sort},
			{:$skip => offset},
			{:$limit => limit}						
			])
		end		
	end
	
	def self.get_country_names
		Place.collection.aggregate([
		{:$unwind => '$address_components'},
		{:$project => {:address_components => {:long_name => 1, :types => 1}}},
		{:$match => {'address_components.types' => 'country'}},
		{:$group => {:_id => '$address_components.long_name', :count => {:$sum => 1}}}
		]).to_a.map {|h| h[:_id]}
	end

	def self.find_ids_by_country_code country_code
		Place.collection.aggregate([ 
		  {:$match => {'address_components.short_name' => country_code, 'address_components.types' => 'country'}},
		  {:$project => { :_id => 1}}		  
		]).map {|doc| doc[:_id].to_s}
	end

	def self.create_indexes
		Place.collection.indexes.create_one({'geometry.geolocation' => Mongo::Index::GEO2DSPHERE})
	end
	
	def self.remove_indexes
		Place.collection.indexes.drop_one('geometry.geolocation_2dsphere')
	end
	
	def self.near(point, max_meters=nil)
		max_meters = max_meters.to_i if !max_meters.nil?
		if !max_meters.nil?
			Place.collection.find({'geometry.geolocation' => {:$near => point.to_hash, :$maxDistance => max_meters}})
		else
			Place.collection.find({'geometry.geolocation' => {:$near => point.to_hash}})
		end
	end
	
	def near(max_meters=nil)
		Place.to_places(Place.near(@location, max_meters))
	end

	def initialize(params={})
		@id = params[:_id].is_a?(BSON::ObjectId) ? params[:_id].to_s : params[:_id]
		@formatted_address = params[:formatted_address]
		@address_components = []
		if !params[:address_components].nil?
			params[:address_components].each{|component| @address_components << AddressComponent.new(component) }
		end
		@location = Point.new(params[:geometry][:geolocation])		
	end
	
	def destroy
		self.class.collection.find(:_id => BSON::ObjectId.from_string(@id)).delete_one()
	end
	
	def photos(offset=0, limit=0)
		Photo.find_photos_for_place(@id).skip(offset).limit(limit).map {|doc| Photo.new(doc)}
	end

	def persisted?
		!@id.nil?
	end
	
end