class Company < BaseModel
	has_many :quotes
	has_many :trades,:foreign_key => 'company_symbol'
	enum status: [:active,:inactive]

	def self.get_for_dropdown(param)
		search = "%#{param.downcase}%"
		Company.select(:id,:company_name,:symbol,:yahoo_symbol).where("lower(company_name) LIKE ? or lower(symbol) LIKE ? ",search,search).order(company_name: :asc).limit(10)
	end
end
