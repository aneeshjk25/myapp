class Company < ActiveRecord::Base
	has_many :quotes
	enum status: [:active,:inactive]
end
