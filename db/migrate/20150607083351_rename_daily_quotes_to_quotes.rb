class RenameDailyQuotesToQuotes < ActiveRecord::Migration
  def up
  	rename_table :daily_quotes, :quotes
  end

  def down
  	rename_table :quotes, :daily_quotes
  end
end
