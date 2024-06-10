class AddColumnCinToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :cin , :string

  end
end
