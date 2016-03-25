class RacerInfo
	include Mongoid::Document
	field :fn, :as => :first_name
	field :ln, :as => :last_name
	field :g, :as => :gender
	field :yr, type: Integer, :as => :birth_year
	field :res, type: Address, :as => :residence
	field :racer_id, as: :_id
	field :_id, default:->{ racer_id }
	
	embedded_in :parent, polymorphic: true

	validates :first_name, :presence => {:message => "can't be blank"}
	validates :last_name, :presence => {:message => "can't be blank"}
	validates :gender, :presence => true, :inclusion => {:in => %w(M F), :message => "must be M or F"}
	validates :birth_year, :presence => true, :numericality => {:less_than => Date.today.year, :message => "must in past"}


	["city", "state"].each do |action|
		define_method("#{action}") do
			self.residence ? self.residence.send("#{action}") : nil
		end
		define_method("#{action}=") do |name|
			object=self.residence ||= Address.new
			object.send("#{action}=", name)
			self.residence=object
		end
	end

end
