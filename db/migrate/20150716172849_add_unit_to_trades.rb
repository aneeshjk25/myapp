class AddUnitToTrades < ActiveRecord::Migration
  def up
  	add_column :trades,:unit,:integer
  end
end
