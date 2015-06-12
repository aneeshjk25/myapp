class Company < BaseModel
	has_many :quotes
	enum status: [:active,:inactive]
end
