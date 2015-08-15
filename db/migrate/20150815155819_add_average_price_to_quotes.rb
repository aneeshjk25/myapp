class AddAveragePriceToQuotes < ActiveRecord::Migration
  
  def up
  	add_column :quotes,:average_price,:float
  end

  def down
  	remove_column :quotes,:average_price
  end
end
=begin

Add a new average price field to quotes table
avera price will be average of all four quotes

use the following query to update existing quotes to have a real average price value
UPDATE quotes SET average_price = ((open_price+close_price+high_price+low_price)/4);

use the following query to test if the update was successfull
select count(id) from quotes where ((open_price+close_price+high_price+low_price)) -average_price*4 != 0 ;

=end
