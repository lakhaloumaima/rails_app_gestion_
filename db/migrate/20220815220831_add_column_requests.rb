class AddColumnRequests < ActiveRecord::Migration[7.0]
  def change

    add_column :requests, :days, :integer   , default: 0 
    
  end
end
