class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
	  t.string :company_name
	  t.string :industry
	  t.string :symbol
	  t.string :yahoo_symbol
	  t.string :series
	  t.string :isin_code

      t.timestamps null: false
    end
  end
end
