class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change

    add_column :users, :last_name, :string
    add_column :users, :first_name, :string
    add_column :users, :address, :string
    add_column :users, :phone , :integer 
    add_column :users, :role , :integer , default: "0" 
    add_column :users, :email_confirmed, :boolean, :default => false
    add_column :users, :confirm_token, :string

  end
end
