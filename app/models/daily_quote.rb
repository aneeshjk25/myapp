class DailyQuote < ActiveRecord::Base
	belongs_to :company
	enum status: [:active,:inactive]
end
