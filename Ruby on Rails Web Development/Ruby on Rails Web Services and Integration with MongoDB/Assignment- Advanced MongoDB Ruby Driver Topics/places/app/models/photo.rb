class Photo
	
	attr_accessor :id, :location
	attr_writer :contents
	
	def self.mongo_client
		Mongoid::Clients.default
	end
	
	def initialize(params=nil)
		if !params.nil?
			@id = params[:_id].to_s if !params[:_id].nil?
			@location = Point.new(params[:metadata][:location]) if !params[:metadata].nil?
			@place = params[:metadata][:place] if !params[:metadata].nil?
		end
	end
	
	def persisted?
		!@id.nil?
	end
	
	def save	
		if !persisted?
			gps = EXIFR::JPEG.new(@contents).gps
			location = Point.new(:lng => gps.longitude, :lat => gps.latitude)
			@contents.rewind
			description = {}
			description[:content_type] = 'image/jpeg'
			description[:metadata] = {
				:location => location.to_hash,
				:place => @place
			}
			@location = Point.new(location.to_hash)
			grid_file = Mongo::Grid::File.new(@contents.read, description)
			@id = self.class.mongo_client.database.fs.insert_one(grid_file).to_s
		else
			result = self.class.mongo_client.database.fs.find(:_id => BSON::ObjectId.from_string(@id)).first
			result[:metadata][:location] = @location.to_hash
			result[:metadata][:place] = @place
			self.class.mongo_client.database.fs.find(:_id => BSON::ObjectId.from_string(@id)).update_one(result)
		end
	end
	
	def self.all(offset=0, limit=0)
		mongo_client.database.fs.find.skip(offset).limit(limit).map { |doc| Photo.new(doc) }
	end
	
	def self.find id
		result = mongo_client.database.fs.find(:_id => BSON::ObjectId.from_string(id)).first
		Photo.new(result) if !result.nil?
	end
	
	def self.find_photos_for_place place_id
		place_id = BSON::ObjectId.from_string(place_id) if place_id.is_a? String
		mongo_client.database.fs.find({'metadata.place' => place_id})
	end
	
	def contents
		f = self.class.mongo_client.database.fs.find_one(:_id => BSON::ObjectId.from_string(@id))
	    if f 
	      buffer = ""
	      f.chunks.reduce([]) do |x, chunk| 
	          buffer << chunk.data.data 
	      end
	      return buffer
	    end 
	end
	
	def destroy
		self.class.mongo_client.database.fs.find(:_id => BSON::ObjectId.from_string(@id)).delete_one		
	end
	
	def find_nearest_place_id max_meters
	    Place.near(@location, max_meters).limit(1).projection({:_id => 1}).first[:_id]
	end
	
	def place
		if !@place.nil?
			Place.find(@place.to_s)
		end
	end  
 
	def place=(new_place)
		if new_place.is_a? String
			@place = BSON::ObjectId.from_string(new_place)
		elsif new_place.is_a? Place
			@place = BSON::ObjectId.from_string(new_place.id)
		else			
			@place = new_place
		end
	end
	
end