class AddUnitToTrades < ActiveRecord::Migration
  def up
  	add_column :trades,:unit,:integer
  end

  def down
  	remove_column :trades,:unit
  end
end
