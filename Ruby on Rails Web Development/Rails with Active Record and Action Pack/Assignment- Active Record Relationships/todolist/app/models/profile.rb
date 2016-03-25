class Profile < ActiveRecord::Base
	belongs_to :user
	validates :gender, :inclusion => %w(male female) 
	validate :first_and_last_name, :boy_sue

	def first_and_last_name
		if (self.first_name.nil? and self.last_name.nil?)
			errors.add :first_name, 'cannot be nil'
			errors.add :last_name, 'cannot be nil'
		end
	end
	
	def boy_sue
		if (self.first_name == 'Sue' and self.gender == 'male')
			errors.add :gender, 'gender must be female'
		end
	end
	
	def self.get_all_profiles(min_birth_year, max_birth_year)
		where('birth_year BETWEEN ? AND ?', min_birth_year, max_birth_year).order(birth_year: :asc)
	end
end
