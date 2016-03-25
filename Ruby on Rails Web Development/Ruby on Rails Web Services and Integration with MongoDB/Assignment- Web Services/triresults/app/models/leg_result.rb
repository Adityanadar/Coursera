class LegResult
	include Mongoid::Document
	field :secs, type: Float
	
	after_initialize :calc_ave
	
	embedded_in :entrant
	embeds_one :event, as: :parent
	
	validates :event, :presence => {:message => "can't be blank"}
	
	def calc_ave
	end
	
	def secs=(value)
		self[:secs] = value
		calc_ave
	end
end