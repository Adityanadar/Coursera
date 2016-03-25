class Point

	attr_accessor :longitude, :latitude
	
	def initialize(params={})
		@longitude = params[:lng] || (params[:coordinates][0] if params[:type]=='Point')
		@latitude = params[:lat] || (params[:coordinates][1] if params[:type]=='Point')
	end
	
	def to_hash
		HashWithIndifferentAccess.new({type:self.class.to_s, coordinates:[@longitude, @latitude]})
	end	

end