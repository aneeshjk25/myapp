class AddStatusToCompanies < ActiveRecord::Migration
  def up
  	add_column :companies, :status, :integer,:null => false,:default => 0
  end

  def down
  	remove_column :companies, :status
  end
end
