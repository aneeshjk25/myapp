class CreateTrades < ActiveRecord::Migration
  def up
    create_table :trades do |t|
      t.string :company_symbol
      t.integer :trade_type,null: false #open close  : is it a new trade, or a trade s being closed
      t.integer :reference				#best,worst,none :the reason behind doing the trade
      t.integer :trade_transaction_type #buy,sell  : is it buy or sell
      t.decimal  :amount					#amount of trade : amount of trade
      t.datetime :time_of_trade
      t.timestamps null: false	
    end
  end
  def down
  	drop_table :trades
  end
end
