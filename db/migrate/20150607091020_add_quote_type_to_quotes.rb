class AddQuoteTypeToQuotes < ActiveRecord::Migration
  def up
  	add_column :quotes, :quote_type, :integer,:null => false,:default => 0
  end

  def down
  	remove_column :quotes, :quote_type
  end
end
