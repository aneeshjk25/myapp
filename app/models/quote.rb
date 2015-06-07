class Quote < ActiveRecord::Base
	belongs_to :company
	enum status: [:active,:inactive]
	enum quote_type: [:na,:minute,:hourly,:daily,:monthly]
end
