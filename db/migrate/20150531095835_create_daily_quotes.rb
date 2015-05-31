class CreateDailyQuotes < ActiveRecord::Migration
  def up
    create_table :daily_quotes do |t|
	  t.references :company, index: true 	 	 
	  t.date   :quote_date
	  t.float  :open_price
	  t.float  :close_price
	  t.float  :low_price
	  t.float  :high_price
	  t.float  :volume

      t.timestamps null: false
    end
  end

  def down
  	drop_table :daily_quotes
  end
end
