class Racer
	include ActiveModel::Model

	attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs
	
	def initialize(params={})
		@id = params[:_id].nil? ? params[:id] : params[:_id].to_s
		@number = params[:number].to_i
		@first_name = params[:first_name]
		@last_name = params[:last_name]
		@gender = params[:gender]
		@group = params[:group]
		@secs = params[:secs].to_i
	end

	def self.mongo_client
		Mongoid::Clients.default
	end
	
	def self.collection
		mongo_client['racers']
	end

	def self.all(prototype={}, sort={}, skip=0, limit=nil)
	
		prototype=prototype.symbolize_keys.slice(:number, :first_name, :last_name, :gender, :group, :secs) if !prototype.nil?

		result= collection.find(prototype)
		      .projection({_id:true, number:true, first_name:true, last_name:true, gender:true, group:true, secs:true})
		      .sort(sort)
		      .skip(skip)
		
		result=result.limit(limit) if !limit.nil?
		
		return result

	end	

	def self.find id
		result=collection.find(:_id=>BSON::ObjectId(id))
					.projection({_id:true, number:true, first_name:true, last_name:true, gender:true, group:true, secs:true})
					.first       
		return result.nil? ? nil : Racer.new(result)
	end

	def self.paginate(params)
		page=(params[:page] || 1).to_i
		limit=(params[:per_page] || 30).to_i
		skip=(page-1)*limit
		sort={number:1}
		
		#get the associated page of Racers -- eagerly convert doc to Racer
		racers=[]
		all({}, sort, skip, limit).each do |racer|
			racers << Racer.new(racer)
		end

		#get a count of all documents in the collection
		total=all({}, sort, 0, 1).count
		
		WillPaginate::Collection.create(page, limit, total) do |pager|
			pager.replace(racers)
		end  
	end

	def save
		result = self.class.collection.insert_one(number:@number, first_name:@first_name, last_name:@last_name, gender:@gender, group:@group, secs:@secs)
		@id = result.inserted_id.to_s
	end

	def update(params)
		@number=params[:number].to_i
		@first_name=params[:first_name]
		@last_name=params[:last_name]
		@gender = params[:gender]
		@group = params[:group]
		@secs=params[:secs].to_i
		params.slice!(:number, :first_name, :last_name, :gender, :group, :secs) if !params.nil?
		self.class.collection
				.find(:_id=>BSON::ObjectId(@id))
				.update_one(:$set=>{number:@number,first_name:@first_name,last_name:@last_name,gender:@gender,group:@group,secs:@secs})
	end

	def destroy
		self.class.collection
			.find(:_id=>BSON::ObjectId(@id))
			.delete_one
	end

	def persisted?
		!@id.nil?
	end

	def created_at
		nil
	end
	
	def updated_at
		nil
	end

end