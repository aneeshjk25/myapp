class Company < ActiveRecord::Base
	has_many :daily_quotes
	enum status: [:active,:inactive]
end
