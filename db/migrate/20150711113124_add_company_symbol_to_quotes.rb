class AddCompanySymbolToQuotes < ActiveRecord::Migration
  def up
  	add_column :quotes, :company_symbol, :string
  end
  def down
  	remove_column :quotes,:company_symbol
  end
end
