class AddQuoteTimeStampToQuotes < ActiveRecord::Migration
  def up
  	add_column :quotes, :quote_timestamp, :datetime
  end

  def down
  	remove_column :quotes, :quote_timestamp
  end
end
