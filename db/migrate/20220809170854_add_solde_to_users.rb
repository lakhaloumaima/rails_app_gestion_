class AddSoldeToUsers < ActiveRecord::Migration[7.0]
  def change

    add_column :users, :solde, :integer

  end
end
