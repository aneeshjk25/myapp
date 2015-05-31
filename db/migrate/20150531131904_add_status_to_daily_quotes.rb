class AddStatusToDailyQuotes < ActiveRecord::Migration
  def up
  	add_column :daily_quotes, :status, :integer,:null => false,:default => 0
  end

  def down
  	remove_column :daily_quotes, :status
  end

end