class Event
	include Mongoid::Document
	field :o, type: Integer, :as => :order
	field :n, type: String, :as => :name
	field :d, type: Float, :as => :distance
	field :u, type: String, :as => :units
	
	embedded_in :parent, polymorphic: true, touch: true

	validates :order, :presence => {:message => "can't be blank"}
	validates :name, :presence => {:message => "can't be blank"}
	
	def meters
		case u
			when "miles" then (d*1609.34)
			when "meters" then d
			when "kilometers" then (d*1000.0)
			when "yards" then (d*0.9144)
			else nil
		end
	end
	
	def miles
		case u
			when "meters" then (d*0.000621371)
			when "miles" then d
			when "kilometers" then (d*0.621371)
			when "yards" then (d*0.000568182)
			else nil
		end
	end
  
end
