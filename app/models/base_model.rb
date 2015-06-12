class BaseModel < ActiveRecord::Base
	self.abstract_class = true
	
	def check_duplicate_and_insert data,condition
	end

end
